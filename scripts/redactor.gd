extends Area2D

@onready var timer := Timer.new()

func _mouse_enter() -> void:
	PickupController.over_redactor = true

func _mouse_exit() -> void:
	PickupController.over_redactor = false

func _ready() -> void:
	timer.wait_time = 3.
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout() -> void:
	if not PickupController.has_pickup:
		var bodies := get_overlapping_bodies()
		for body in bodies:
			if body is Element:
				body.emit_signal("pickable_removed")
				body.queue_free()
