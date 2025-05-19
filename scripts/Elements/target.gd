extends Element

@export var is_target := true
@export var target_r = 3
@export var target_g = 3
@export var target_b = 3

var r := 0
var g := 0
var b := 0

@onready var solved = false

var InfoBox = preload("res://scenes/Info/InfoBox.tscn")

func _ready() -> void:
	super._ready()
	if is_target:
		add_to_group("Targets", true)

func _emit(data: RayData) -> void:
	if data.id < RayIdChecker.max_id:
		r = data.red_p
		g = data.green_p
		b = data.blue_p
		solved = (data.red_p == target_r and data.green_p == target_g and data.blue_p == target_b)

func _reset(id: int) -> void:
	solved = false

func _popup() -> void:
	var box = InfoBox.instantiate()
	box.text = "DET: " + str(r + g + b)
	if is_target:
		box.text += ("\nREQ: R" + str(target_r) + " G:" + str(target_g) + " B" + str(target_b) )
	box.global_position = global_position + Vector2.DOWN * 40
	get_tree().root.add_child(box)
