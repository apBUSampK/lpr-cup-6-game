extends Label

func _ready() -> void:
	$Area2D.mouse_exited.connect(queue_free)
