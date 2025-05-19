extends Control

signal continue_game
signal new_game
signal options
signal exit_game
signal change_locale

func disable_continue():
	$MenuButtons/VBoxContainer/Continue.disabled = true

func enable_continue():
	$MenuButtons/VBoxContainer/Continue.disabled = false

func disable_new_game():
	$"MenuButtons/VBoxContainer/New Game".disabled = true

func enable_new_game():
	$"MenuButtons/VBoxContainer/New Game".disabled = false

func _on_change_locale_pressed() -> void:
	emit_signal("change_locale")

func _on_continue_pressed() -> void:
	emit_signal("continue_game")

func _on_new_game_pressed() -> void:
	emit_signal("new_game")

func _on_options_pressed() -> void:
	emit_signal("options")

func _on_exit_pressed() -> void:
	emit_signal("exit_game")
