extends Button
class_name ChoiceButton

const MY_SCENE := preload("res://ui/button.tscn")
const CLICK_SOUND := preload("res://assets/sounds/ui-select.wav")

var old_stylebox: StyleBox

signal choice_taken(id: String)

static func init(text, position) -> ChoiceButton:
	var new_button: ChoiceButton = MY_SCENE.instantiate()
	new_button.position = position
	new_button.text = text
	return new_button

func _ready():
	$AudioStreamPlayer.stream = CLICK_SOUND
	old_stylebox = get_theme_stylebox("normal")

func _on_pressed():
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	choice_taken.emit(text)

func _on_mouse_entered():
	grab_focus.call_deferred()

func _on_mouse_exited():
	release_focus.call_deferred()

func _on_focus_entered():
	var new_stylebox = get_theme_stylebox("normal").duplicate()
	
	new_stylebox.content_margin_left = 8
	add_theme_stylebox_override("normal", new_stylebox)
	$AudioStreamPlayer.play()

func _on_focus_exited():
	remove_theme_stylebox_override("normal")
	add_theme_stylebox_override("normal", old_stylebox)

