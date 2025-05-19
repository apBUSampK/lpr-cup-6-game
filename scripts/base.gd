extends Node2D

@onready var game_scene := preload("res://scenes/Levels/Level1.tscn")

var locale_en := false
var level_number := -1
var game_inst : Node2D

enum DIALOGUES {
	Initial = 1,
	PracticeOnSimple = 2,
	TrySolveTheFollowing = 3,
	AReallyDifficult = 4,
}

func _ready() -> void:
	if not FileAccess.file_exists("user://lprGame.save"):
		print("No save data found")
		$MenuControl/Menu.disable_continue()
	else:
		$MenuControl/Menu.enable_continue()

func change_locale() -> void:
	locale_en = !locale_en
	if locale_en:
		TranslationServer.set_locale("en")
		print("locale en")
	else:
		TranslationServer.set_locale("ru")
		print("locale ru")
# Main menu
func _on_menu_change_locale() -> void:
	change_locale()

func _on_menu_continue_game() -> void:
	if level_number == -1 and FileAccess.file_exists("user://lprGame.save"):
		var save_file = FileAccess.open("user://lprGame.save", FileAccess.READ)
		level_number = save_file.get_32()
		save_file.close()
		print("loaded level number = ", level_number)
	$MenuControl/Menu.hide()

func _on_menu_new_game() -> void:
	print("new game")
	$MenuControl/Menu.hide()
	$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.Initial)
	$MenuControl/Dialogue.show()

func _on_menu_options() -> void:
	$MenuControl/Options.show()

func _on_menu_exit_game() -> void:
	get_tree().quit()

# Options screen
func _on_options_change_locale() -> void:
	change_locale()

func _on_options_back() -> void:
	$MenuControl/Options.hide()

func _on_options_music_lvl(level: float) -> void:
	$Music.volume_linear = level

func _on_options_sfx_lvl(level: float) -> void:
	$SFX.volume_linear = level

func _on_dialogue_dialogue_end(dialogue_number: int) -> void:
	match dialogue_number:
		DIALOGUES.Initial:
			$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.PracticeOnSimple)
		DIALOGUES.PracticeOnSimple:
			$MenuControl/Dialogue.hide()
			level_number = 1
			game_inst = game_scene.instantiate()
			add_child(game_inst)
			game_inst.next.connect(_load_next_scene)
			game_inst.pause.connect(_pause)

func _pause() -> void:
	var save_file = FileAccess.open("user://lprGame.save", FileAccess.WRITE)
	save_file.store_32(level_number)
	save_file.close()
	$MenuControl/Menu.show()
	$MenuControl/Menu.disable_new_game()
	$MenuControl/Menu.enable_continue()

# Switch to next game scene
func _load_next_scene(next_scene: PackedScene) -> void:
	game_inst.queue_free()
	game_inst = next_scene.instantiate()
	add_child(game_inst)
	game_inst.next.connect(_load_next_scene)
