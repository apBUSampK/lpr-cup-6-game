extends Label

func _input(event: InputEvent) -> void:
	if event is InputEventKey and visible:
		if event.is_action_pressed("new_level") and event.pressed and not event.is_echo():
			get_parent().emit_signal("next", get_parent().next_scene)
