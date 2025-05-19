extends Node2D

@onready var player = preload("res://scenes/rigid_body_2d.tscn")

func _ready() -> void:
	var inst := player.instantiate()
	inst.position = Vector2(400, 200)
	print("ready")
	add_child(inst)

func _process(delta: float) -> void:
	var dir := Vector2(0,0)
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("q"):
		$RigidBody2D.apply_torque(-20.0)
	if Input.is_action_pressed("r"):
		$RigidBody2D.apply_torque(20.0)
	if dir:
		$RigidBody2D.apply_force(dir * 10)
	if Input.is_action_just_pressed("ui_accept"):
		save_game()
	if Input.is_action_just_pressed("load"):
		load_game()

func save_game() -> void:
	# IDK where to save the game, path is changeable
	var save_file = FileAccess.open("user://lprGame.save", FileAccess.WRITE)
	# We save every object in "Persistent" group
	for node in get_tree().get_nodes_in_group("Persistent"):
		# This check does not work for some reason. 
		# "node.scene_file_path" is always empty. je ne sais pas pourqoi
		#if node.scene_file_path.is_empty():
			#print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			#continue
		# Check the node has a save function.
		if !node.has_method("get_save_dict"):
			print("persistent node '%s' is missing a get_save_dict() function, skipped" % node.name)
			continue
		# Call the node's save function.
		var node_data = node.call("get_save_dict")
		print("Saving data:", node_data)
		var json_string = JSON.stringify(node_data)
		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
	save_file.close()

# Copied from godot website
func load_game():
	if not FileAccess.file_exists("user://lprGame.save"):
		print("ERROR: No save data found")
		return # Error! We don't have a save to load.
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for i in save_nodes:
		i.queue_free()
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://lprGame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		# Creates the helper class to interact with JSON.
		var json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		# Get the data from the JSON object.
		var node_data = json.data
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		if !new_object.has_method("recover_from_dict"):
			print("persistent node '%s' is missing a recover_from_dict() function, skipped" % new_object.name)
			continue
		new_object.call("recover_from_dict", node_data)
