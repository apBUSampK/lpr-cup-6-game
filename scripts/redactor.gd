extends Area2D

func _mouse_enter() -> void:
	PickupController.over_redactor = true

func _mouse_exit() -> void:
	PickupController.over_redactor = false
