extends Button
class_name ChoiceButton

const MY_SCENE = preload("res://button.tscn")
signal choice_taken(id: String)

static func init(text, position) -> ChoiceButton:
	var new_button: ChoiceButton = MY_SCENE.instantiate()
	new_button.position = position
	new_button.text = text
	return new_button

func _on_pressed():
	choice_taken.emit(text)
