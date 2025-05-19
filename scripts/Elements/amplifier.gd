extends Element

var emitted_rays : Array[RayCast2D]

enum Specter {NONE, RED, GREEN, BLUE}

@export var amplifier_type = Specter.RED
@export var amplifier_power : int = 1
@export var max_power = 5

func _ready() -> void:
	super._ready()
	emitted_rays.resize(RayIdChecker.max_id)
	emitted_rays.fill(null)
	get_node("Line2D").default_color = Color(1. if amplifier_type == 1 else 0.,
											1. if amplifier_type == 2 else 0.,
											1. if amplifier_type == 3 else 0.,)

func _emit(data: RayData) -> void:
	if data.id < RayIdChecker.max_id:
		if emitted_rays[data.id] == null:
			emitted_rays[data.id] = RayScene.instantiate()		
			add_child(emitted_rays[data.id])
			emitted_rays[data.id].setup(data.red_p, data.green_p, data.blue_p, RayIdChecker.get_id(), data.incidence, Vector2.DOWN, Vector2.INF)
		var ray = emitted_rays[data.id]
		ray.global_position = data.incidence
		ray.global_rotation = -data.heading.angle_to(Vector2.DOWN)
		
		var red = data.red_p
		var green = data.green_p
		var blue = data.blue_p
		
		match amplifier_type:
			1:
				if red > 0:
					red += amplifier_power
					if red > max_power:
						red = max_power
			2:
				if green > 0:
					green += amplifier_power
					if green > max_power:
						green = max_power
			3:
				if blue > 0:
					blue += amplifier_power
					if blue > max_power:
						blue = max_power
		
		ray.setup(red, green, blue, -1, data.incidence, Vector2.DOWN.rotated(ray.global_rotation), Vector2.INF)

func _reset(id: int) -> void:
	remove_child(emitted_rays[id])
	emitted_rays[id].queue_free()
	emitted_rays[id] = null
