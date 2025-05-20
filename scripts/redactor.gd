extends Area2D

func _mouse_enter() -> void:
	PickupController.over_redactor = true

func _mouse_exit() -> void:
	PickupController.over_redactor = false

func _process(delta: float) -> void:
	if not PickupController.has_pickup:
		var bodies := get_overlapping_bodies()
		for body in bodies:
			if body is Element:
				body.emit_signal("pickable_removed")
				body.queue_free()
