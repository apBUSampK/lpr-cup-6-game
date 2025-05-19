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
