class_name RayData
extends RefCounted

var origin: Vector2
var incidence: Vector2
var heading: Vector2

var red_p: int
var green_p: int
var blue_p: int

var id: int

func _init(r=3, g=3, b=3):
	red_p = r
	green_p = g
	blue_p = b
	
	origin = Vector2.INF
	incidence = origin
	heading = origin
	id = - 1
