extends Control

const LINES_VISIBLE := 3

signal dialogue_end(dialogue_number: int)
@onready var text_box = $Dialogue/Text

const cat_appears_en := [1, 0, 0, 0, 0]
const cat_appears_ru := [1, 0, 0, 0, 0]

var dialogue_number = 0

func UpdateDialogue(number: int, prefix: String = "DIALOGUE_") -> void:
	$Dialogue/Text.text = tr(prefix+str(number))
	$Dialogue/Text.lines_skipped = 0
	dialogue_number = number

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and not event.is_echo() and event.is_action_pressed("ui_accept"):
		text_box.lines_skipped += LINES_VISIBLE
		var cat_appears_line = 0
		if dialogue_number < len(cat_appears_en):
			cat_appears_line = cat_appears_en[dialogue_number]
			if TranslationServer.get_locale() == 'ru_RU':
				cat_appears_line = cat_appears_ru[dialogue_number]
		if text_box.lines_skipped >= cat_appears_line:
			$Sphinx.show()
		if text_box.lines_skipped >= text_box.get_line_count():
			emit_signal("dialogue_end", dialogue_number)
