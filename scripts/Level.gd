class_name Level
extends Node2D

@export var next_scene : PackedScene

signal next(next_scene : PackedScene)
signal pause

func _process(delta: float) -> void:
	var solved := true
	for node in get_tree().get_nodes_in_group("Targets"):
		if not node.solved:
			solved = false
			break
	if solved:
		$Congrats.show()

func _ready() -> void:
	$Pause.connect("pressed", _on_pause_pressed)
	PickupController.has_pickup = false

func _on_pause_pressed() -> void:
	print("pause")
	emit_signal("pause")

func _on_cat_timer_timeout():
	$CatContainer/CatPhrase.UpdateDialogue(randi_range(1, 27), "PHRASE_")
	$CatContainer/CatPhrase.show()
	$CatContainer/CatTimer.wait_time = randi_range(60, 120)
	$CatContainer/CatTimer.start()

func _on_cat_phrase_dialogue_end(dialogue_number):
	$CatContainer/CatPhrase.hide()

func _on_tutorial_1_tutorial_closed():
	$CatContainer/CatTimer.start()
