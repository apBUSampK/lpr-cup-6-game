extends Element

var emitted_rays : Array[RayCast2D]

enum Specter {NONE, RED, GREEN, BLUE}

@export var red_power : int = 1
@export var green_power : int = 1
@export var blue_power : int = 1
@export var max_spectral_power = 5

func _ready() -> void:
	super._ready()
	emitted_rays.resize(RayIdChecker.max_id)
	emitted_rays.fill(null)

func _emit(data: RayData) -> void:
	if data.id < RayIdChecker.max_id:
		if emitted_rays[data.id] == null:
			emitted_rays[data.id] = RayScene.instantiate()		
			emitted_rays[data.id].show_behind_parent = true
			add_child(emitted_rays[data.id])
			emitted_rays[data.id].setup(data.red_p, data.green_p, data.blue_p, RayIdChecker.get_id(), data.incidence, Vector2.DOWN, Vector2.INF)
		var ray = emitted_rays[data.id]
		ray.global_position = data.incidence
		ray.global_rotation = -data.heading.angle_to(Vector2.DOWN)
		
		var red = data.red_p
		var green = data.green_p
		var blue = data.blue_p
		
		if red > 0:
			red += red_power
			if red > max_spectral_power:
				red = max_spectral_power
						
		if green > 0:
			green += green_power
			if green > max_spectral_power:
				green = max_spectral_power

		if blue > 0:
			blue += blue_power
			if blue > max_spectral_power:
				blue = max_spectral_power
		
		ray.setup(red, green, blue, -1, data.incidence, Vector2.DOWN.rotated(ray.global_rotation), Vector2.INF)

func _reset(id: int) -> void:
	remove_child(emitted_rays[id])
	emitted_rays[id].queue_free()
	emitted_rays[id] = null
