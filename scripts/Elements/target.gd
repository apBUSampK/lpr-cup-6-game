extends Element

var collected_rays : Array[RayData]

@export var is_target := true
@export var target_r = 3
@export var target_g = 3
@export var target_b = 3
@export var target_tot = -1

var r := 0
var g := 0
var b := 0

@onready var solved = false

var InfoBox = preload("res://scenes/Info/InfoBox.tscn")

func _ready() -> void:
	super._ready()
	
	collected_rays.resize(RayIdChecker.max_id)
	collected_rays.fill(null)
	
	if is_target:
		add_to_group("Targets", true)

func _emit(data: RayData) -> void:
	if data.id < RayIdChecker.max_id:
		if collected_rays[data.id] == null:
			r += data.red_p
			g += data.green_p
			b += data.blue_p
			collected_rays[data.id] = RayData.new(data.red_p, data.green_p, data.blue_p)
	solved = (r == target_r and g == target_g and b == target_b) if target_tot < 0 else (target_tot == (r + g + b))

func _reset(id: int) -> void:
	r -= collected_rays[id].red_p
	g -= collected_rays[id].green_p
	b -= collected_rays[id].blue_p
	collected_rays[id] = null
	

func _popup() -> void:
	var box = InfoBox.instantiate()
	box.text = "DET TOTAL: " + str(r + g + b)
	if is_target:
		box.text += ("\nREQ: R" + str(target_r) + " G" + str(target_g) + " B" + str(target_b) ) if target_tot < 0 else ("\nREQ TOTAL: " + str(target_tot))
	box.global_position = global_position + Vector2.DOWN * 40
	get_tree().root.add_child(box)
