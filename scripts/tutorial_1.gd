extends TextureRect

signal tutorial_closed
signal tutorial_opened

func _input(event: InputEvent) -> void:
	if visible:
		if event is InputEventKey and event.is_pressed() and event.is_action_pressed("ui_accept"):
			emit_signal("tutorial_closed")
			hide()
	if not visible:
		if event is InputEventKey and event.is_pressed and event.is_action_pressed("hint"):
			emit_signal("tutorial_opened")
			show()
