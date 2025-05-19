extends RigidBody2D

func _ready() -> void:
	add_to_group("Persistent")

func get_save_dict() -> Dictionary:
	var res := {
		"filename" : scene_file_path,
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"vel_x" : linear_velocity.x,
		"vel_y" : linear_velocity.y,
		"rotation": rotation,
	}
	return res

func recover_from_dict(dict):
	position = Vector2(dict['pos_x'], dict['pos_y'])
	linear_velocity = Vector2(dict['vel_x'], dict['vel_y'])
	rotation = dict['rotation']
