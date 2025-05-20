extends Control

signal reward_exit()   

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SPACE and event.pressed and visible:
			emit_signal("reward_exit")
