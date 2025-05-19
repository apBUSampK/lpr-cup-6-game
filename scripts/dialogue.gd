extends Control

const LINES_VISIBLE := 3

signal dialogue_end
@onready var text_box = $Dialogue/Text

const cat_appears_en := [0]
const cat_appears_ru := [0]

func UpdateDialogue(number: int) -> void:
	print(number)
	$Dialogue/Text.text = tr("DIALOGUE_"+str(number))
	$Dialogue/Text.lines_skipped = 0

func _input(event: InputEvent) -> void:
	if visible:
		if event is InputEventKey and not event.is_echo() and event.is_action_pressed("ui_accept"):
			text_box.lines_skipped += LINES_VISIBLE
			if text_box.lines_skipped >= text_box.get_line_count():
				emit_signal("dialogue_end")
