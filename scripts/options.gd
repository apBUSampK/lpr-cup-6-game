extends Control

signal change_locale
signal music_lvl(level: float)
signal sfx_lvl(level: float)
signal back

func _on_change_locale_pressed() -> void:
	print("change locale")
	emit_signal("change_locale")

func _on_return_pressed() -> void:
	print("return")
	emit_signal("back")

func _on_music_drag_ended(value_changed: bool) -> void:
	if value_changed:
		emit_signal("music_lvl", $Music.value)

func _on_sfx_drag_ended(value_changed: bool) -> void:
	if value_changed:
		emit_signal("sfx_lvl", $SFX.value)
