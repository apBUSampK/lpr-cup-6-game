extends TextureRect

signal tutorial_closed

func _input(event: InputEvent) -> void:
	if visible:
		if event is InputEventKey and event.is_pressed() and event.is_action_pressed("ui_accept"):
			emit_signal("tutorial_closed")
			queue_free()
