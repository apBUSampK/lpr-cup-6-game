extends StaticBody2D

@export var r := 3
@export var g := 3
@export var b := 3

func _ready() -> void:
	var ray := $RayCast2D
	ray.data.red_p = r
	ray.data.green_p = g
	ray.data.blue_p = b
	ray.recolor()
	
	$Exclusion.add_to_group("Element_Exclusion")

var click_count := 0
const CLICK_THRESHOLD := 6
signal too_much_clicks

func _on_exclusion_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		click_count += 1
		if click_count > CLICK_THRESHOLD:
			click_count = 0
			emit_signal("too_much_clicks")
