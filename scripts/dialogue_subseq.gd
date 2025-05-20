extends Control

const LINES_VISIBLE := 3

@export var next_scene : PackedScene

signal next(next_scene : PackedScene)
@onready var text_box = $Dialogue/Text

var dialogue_number = 3

func _ready() -> void:
	$Dialogue/Text.text = tr("DIALOGUE_"+str(dialogue_number))
	$Dialogue/Text.lines_skipped = 0

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and not event.is_echo() and event.is_action_pressed("ui_accept"):
		text_box.lines_skipped += LINES_VISIBLE
		if text_box.lines_skipped >= text_box.get_line_count():
			emit_signal("next", next_scene)
