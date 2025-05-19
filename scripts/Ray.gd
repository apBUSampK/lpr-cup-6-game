extends RayCast2D

@export var Propagation_Range = 10000
@export var max_power = 5

@onready var data = RayData.new()
@onready var line : Line2D = self.get_node("Line2D")

func _ready() -> void:
	if data.id == 0:
		setup(3, 3, 3, 0, Vector2.ZERO, Vector2.ZERO, Vector2.INF)

func _process(delta: float) -> void:
	data.origin = global_position
	data.heading = Vector2.DOWN.rotated(global_rotation)
	
	line.clear_points()
	line.add_point(Vector2.ZERO)
	
	if is_colliding():
		var point = get_collision_point()
		data.incidence = point
		line.add_point(Vector2.DOWN * (point - global_position).length())
		var collider = get_collider()
		if collider is Element:
			collider.react(data)
	else:
		data.incidence = Vector2.INF
		line.add_point(Vector2.DOWN * Propagation_Range)

func setup(red_p: int, green_p: int, blue_p: int, id: int, origin: Vector2, heading: Vector2, incidence: Vector2) -> void:
	data.red_p = red_p
	data.green_p = green_p
	data.blue_p = blue_p
	data.id = id if id >= 0 else data.id
	data.origin = origin
	data.heading = heading
	data.incidence = incidence
	
	var alpha = float(red_p**2 + green_p**2 + blue_p**2) / max_power**2 / 3
	var max = max(red_p, green_p, blue_p)
	line.default_color = Color(float(red_p) / max, float(green_p) / max, float(blue_p) / max, alpha)
	

func recolor() -> void:
	var alpha = float(data.red_p**2 + data.green_p**2 + data.blue_p**2) / max_power**2 / 3
	var max = max(data.red_p, data.green_p, data.blue_p)
	line.default_color = Color(float(data.red_p) / max, float(data.green_p) / max, float(data.blue_p) / max, alpha)
