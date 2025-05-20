extends Label

func _input(event: InputEvent) -> void:
	if event is InputEventKey and visible:
		if event.key_label == KEY_N and event.pressed:
			get_parent().emit_signal("next", get_parent().next_scene)
