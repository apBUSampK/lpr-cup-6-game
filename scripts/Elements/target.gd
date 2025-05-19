extends Element

@export var is_target := true
@export var target_r = 3
@export var target_g = 3
@export var target_b = 3

@onready var solved = false

func _ready() -> void:
	super._ready()
	if is_target:
		add_to_group("Targets", true)

func _emit(data: RayData) -> void:
	if data.id < RayIdChecker.max_id:
		solved = (data.red_p == target_r and data.green_p == target_g and data.blue_p == target_b)

func _reset(id: int) -> void:
	solved = false
