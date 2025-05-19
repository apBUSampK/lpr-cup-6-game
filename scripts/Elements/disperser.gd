extends Element

var rays : Dictionary[int, Array]

func _emit(data: RayData) -> void:
	if data.id < RayIdChecker.max_id:
		if !rays.has(data.id):
			rays[data.id] = [RayScene.instantiate(), RayScene.instantiate(), RayScene.instantiate()]
			for ray : RayCast2D in rays[data.id]:
				add_child(ray)
				ray.setup(data.red_p, data.green_p, data.blue_p, RayIdChecker.get_id(), data.incidence, Vector2.DOWN, Vector2.INF)
		for i in range(3):
			rays[data.id][i].global_position = data.incidence
			rays[data.id][i].global_rotation = -data.heading.angle_to(Vector2.DOWN) + (i - 1) * PI/8
			rays[data.id][i].setup(data.red_p if i == 0 else 0., data.green_p if i == 1 else 0., data.blue_p if i ==2 else 0,
			 -1, data.incidence, Vector2.DOWN.rotated(rays[data.id][i].global_rotation), Vector2.INF)

func _reset(id: int) -> void:
	for ray : RayCast2D in rays[id]:
		RayIdChecker.return_id(ray.data.id)
		remove_child(ray)
		ray.queue_free()
	rays.erase(id)
	
	
