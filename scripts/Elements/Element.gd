class_name Element extends StaticBody2D

@export var Max_Frames_Till_Reset = 2
@export var rotation_speed = 1.
@export var redactable = true

var RayScene = preload("res://scenes/Ray.tscn")
@onready var frames_since_hit : PackedInt32Array
@onready var exclusion : Area2D = get_node("Exclusion")
@onready var excluder : ColorRect = get_node("Exclusion/Excluder")

var carry = false
var hovered = false
var overlapping_element = false

signal pickable_removed()

func _ready() -> void:
	add_to_group("Element", true)
	
	exclusion.add_to_group("Element_Exclusion", true)
	
	exclusion.mouse_entered.connect(_hover_up)
	exclusion.mouse_exited.connect(_hover_down)
	
	frames_since_hit.resize(RayIdChecker.max_id)
	frames_since_hit.fill(Max_Frames_Till_Reset + 1)

func react(data: RayData) -> void:
	if not overlapping_element:
		if data.id < RayIdChecker.max_id:
			frames_since_hit[data.id] = 0
		_emit(data)

func _emit(data: RayData) -> void:
	pass

func _reset(id: int) -> void:
	pass

func _popup() -> void:
	pass

func _physics_process(delta: float) -> void:
	for i in frames_since_hit.size():
		if frames_since_hit[i] < Max_Frames_Till_Reset:
			frames_since_hit[i] += 1
			if frames_since_hit[i] == Max_Frames_Till_Reset:
				_reset(i)

func _process(delta: float) -> void:
	overlapping_element = false
	var overlapped_areas = exclusion.get_overlapping_areas()
	for area in overlapped_areas:
		if area.is_in_group("Element_Exclusion"):
			overlapping_element = true
	if overlapping_element:
		excluder.visible = true
	else:
		excluder.visible = false
		
	if carry:
		global_position = get_global_mouse_position()
		rotation += rotation_speed * Input.get_axis("Rotation_cw", "Rotation_ccw") * delta

func _hover_up() -> void:
	hovered = true

func _hover_down() -> void:
	hovered = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT and redactable:
				if carry and not overlapping_element:
					carry = false
					excluder.visible = false
					PickupController.has_pickup = false
					if PickupController.over_redactor:
						emit_signal("pickable_removed")
						queue_free()
				elif hovered and not overlapping_element:
					carry = true
					PickupController.has_pickup = true
			if event.button_index == MOUSE_BUTTON_RIGHT and hovered and not carry:
				_popup()
