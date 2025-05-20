extends Node2D

@onready var game_scene := preload("res://scenes/Levels/Level1.tscn")

var locale_en := false
var level_number := -1
var game_inst : Node

var audio_stream := AudioStreamMP3.new()

enum DIALOGUES {
	Initial = 1,
	TrySolveTheFollowing = 2,
	PracticeOnSimple = 3,
	AReallyDifficult = 4,
	Final = 5	
}

var MUSIC = {
	"MENU": "res://music/Меню.mp3",
	"INGAME": "res://music/InGame.mp3",
	"DIALOG": "res://music/Dialogue.mp3",
	"DF1": "res://music/DF1.mp3",
	"DF2": "res://music/DF2.mp3",
	"DF3": "res://music/DF3.mp3",
	"TF1": "res://music/TF1.mp3",
	"TF2": "res://music/TF2.mp3",
	"TF3": "res://music/TF3.mp3",
}

func _set_music(path: String):
	$Music.stream = load(path)
	$Music.play()

func _ready() -> void:
	TranslationServer.set_locale("ru")
	print("locale ru")
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
		game_inst = load("res://scenes/Levels/Level"+str(level_number)+".tscn").instantiate()
		game_inst.next.connect(_load_next_scene)
		game_inst.pause.connect(_pause)
		add_child(game_inst)
		match level_number:
			6:
				$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.TrySolveTheFollowing)	
			7:
				$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.AReallyDifficult)
			8:
				$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.Final)
			_:
				$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.PracticeOnSimple)
	game_inst.show()
	
	match level_number:
		6:
			_set_music(MUSIC['DF1'])
		7:
			_set_music(MUSIC['DF2'])
		8:
			_set_music(MUSIC['DF3'])
		_:
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
	$Music.volume_linear = (level ** 2) / 12

func _on_options_sfx_lvl(level: float) -> void:
	$SFX.volume_linear = (level ** 2) / 12

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
			$MenuControl/Dialogue.hide()
			$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.PracticeOnSimple)
			_start_new_game_instance()
		DIALOGUES.PracticeOnSimple:
			$MenuControl/Dialogue.hide()
			$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.TrySolveTheFollowing)
			game_inst = load("res://scenes/Levels/Level6.tscn").instantiate()
			add_child(game_inst)
			_set_music(MUSIC['TF1'])
			RayIdChecker._init()
			PickupController.has_pickup = false
			game_inst.next.connect(_load_next_scene)
			game_inst.pause.connect(_pause)
		DIALOGUES.TrySolveTheFollowing:
			$MenuControl/Dialogue.hide()
			$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.AReallyDifficult)
			game_inst = load("res://scenes/Levels/Level7.tscn").instantiate()
			RayIdChecker._init()
			PickupController.has_pickup = false
			add_child(game_inst)
			_set_music(MUSIC['TF2'])
			game_inst.next.connect(_load_next_scene)
			game_inst.pause.connect(_pause)
		DIALOGUES.AReallyDifficult:
			$MenuControl/Dialogue.hide()
			$MenuControl/Dialogue.UpdateDialogue(DIALOGUES.Final)
			game_inst = load("res://scenes/Levels/Level8.tscn").instantiate()
			RayIdChecker._init()
			PickupController.has_pickup = false
			add_child(game_inst)
			_set_music(MUSIC['TF3'])
			game_inst.next.connect(_load_next_scene)
			game_inst.pause.connect(_pause)
		DIALOGUES.Final:
			$MenuControl/Dialogue.hide()
			game_inst = $MenuControl/Reward if locale_en else $MenuControl/Reward2
			game_inst.show()

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
	#cleanup states
	RayIdChecker._init()
	PickupController.has_pickup = false
	
	level_number += 1
	
	match level_number:
		6:
			_set_music(MUSIC['DF1'])
		7:
			_set_music(MUSIC['DF2'])
		8:
			_set_music(MUSIC['DF3'])
	
	game_inst.queue_free()
	if next_scene != null:
		game_inst = next_scene.instantiate()
		add_child(game_inst)
		game_inst.next.connect(_load_next_scene)
		game_inst.pause.connect(_pause)
	else:
		$MenuControl/Dialogue.show()
