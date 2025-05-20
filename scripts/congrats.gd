extends Label

func _input(event: InputEvent) -> void:
	if event is InputEventKey and visible:
		if event.is_action_pressed("ui_accept") and event.pressed:
			get_parent().emit_signal("next", get_parent().next_scene)
