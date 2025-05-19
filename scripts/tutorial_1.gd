extends TextureRect

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.key_label == KEY_SPACE and event.pressed:
			queue_free()
