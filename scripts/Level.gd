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
