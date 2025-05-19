extends Node2D

@onready var game_scene := preload("res://scenes/Levels/Level1.tscn")

var locale_en := false
var level_number := -1
var game_inst : Node2D

var audio_stream := AudioStreamMP3.new()

enum DIALOGUES {
	Initial = 1,
	PracticeOnSimple = 2,
	TrySolveTheFollowing = 3,
	AReallyDifficult = 4,
}

var MUSIC = {
	"MENU": "res://music/Меню.mp3",
	"INGAME": "res://music/InGame.mp3",
	"DIALOG": "res://music/Dialogue.mp3"
}

func _set_music(path: String):
	$Music.stream = audio_stream.load_from_file(path)
	$Music.play()

func _ready() -> void:
	_set_music(MUSIC['MENU'])
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
	game_inst.show()
	_set_music(MUSIC['INGAME'])
	$MenuControl/Menu.hide()

func _on_menu_new_game() -> void:
	print("new game")
	$MenuControl/Menu.hide()
	$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.Initial)
	$MenuControl/Dialogue.show()
	_set_music(MUSIC['DIALOG'])

func _on_menu_options() -> void:
	$MenuControl/Options.show()

func _on_menu_exit_game() -> void:
	_save_game()
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

func _start_new_game_instance():
	level_number = 1
	game_inst = game_scene.instantiate()
	add_child(game_inst)
	game_inst.next.connect(_load_next_scene)
	game_inst.pause.connect(_pause)
	_set_music(MUSIC['INGAME'])

func _on_dialogue_dialogue_end(dialogue_number: int) -> void:
	match dialogue_number:
		DIALOGUES.Initial:
			$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.PracticeOnSimple)
		DIALOGUES.PracticeOnSimple:
			$MenuControl/Dialogue.hide()
			_start_new_game_instance()

func _save_game() -> void:
	var save_file = FileAccess.open("user://lprGame.save", FileAccess.WRITE)
	save_file.store_32(level_number)
	save_file.close()

func _pause() -> void:
	_save_game()
	_set_music(MUSIC['MENU'])
	game_inst.hide()
	$MenuControl/Menu.show()
	$MenuControl/Menu.disable_new_game()
	$MenuControl/Menu.enable_continue()

# Switch to next game scene
func _load_next_scene(next_scene: PackedScene) -> void:
	game_inst.queue_free()
	game_inst = next_scene.instantiate()
	add_child(game_inst)
	game_inst.next.connect(_load_next_scene)
