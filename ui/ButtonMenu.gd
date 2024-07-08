class_name ChoicesMenu
extends Control

const MY_SCENE = preload("res://ui/choices_menu.tscn")
const BUTTON_OFFSET: int = 10

var choices: Array
var buttons: Array
var onChoice: Callable

static func init(position: Vector2, choices: Array, onChoice) -> ChoicesMenu:
	var new_choices_menu: ChoicesMenu = MY_SCENE.instantiate()
	new_choices_menu.position = position
	new_choices_menu.choices = choices
	new_choices_menu.onChoice = onChoice
	return new_choices_menu
	
func _ready():
	var i: int = 0
	while i < len(choices):
		buttons.append(ChoiceButton.init(choices[i], 
						Vector2(self.position.x, 
								self.position.y)))
		i += 1
	
	for btn in buttons:
		btn.set_focus_mode(Control.FOCUS_ALL)
		$MarginContainer/VBoxContainer.add_child(btn)
		btn.connect("choice_taken", onChoice)
		
	buttons[0].grab_focus.call_deferred()
