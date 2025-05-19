extends Element

var emitted_rays : Array[RayCast2D]

func _ready() -> void:
	super._ready()
	emitted_rays.resize(RayIdChecker.max_id)
	emitted_rays.fill(null)

func _emit(data: RayData) -> void:
	if data.id < RayIdChecker.max_id:
		if emitted_rays[data.id] == null:
			emitted_rays[data.id] = RayScene.instantiate()		
			add_child(emitted_rays[data.id])
			emitted_rays[data.id].setup(data.red_p, data.green_p, data.blue_p, RayIdChecker.get_id(), data.incidence, Vector2.DOWN, Vector2.INF)
		var ray = emitted_rays[data.id]
		ray.global_position = data.incidence
		ray.rotation = data.heading.angle_to(Vector2.DOWN.rotated(global_rotation)) - PI
		ray.setup(data.red_p, data.green_p, data.blue_p, -1, data.incidence, Vector2.DOWN.rotated(ray.global_rotation), Vector2.INF)

func _reset(id: int) -> void:
	RayIdChecker.return_id(emitted_rays[id].data.id)
	remove_child(emitted_rays[id])
	emitted_rays[id].queue_free()
	emitted_rays[id] = null
