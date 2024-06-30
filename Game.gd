extends Node2D

@onready var DP: DialogueParser = DialogueParser.new()
@onready var DialogueLabel = $DialogueLabel
@onready var NPCLabel = $NPCLabel

var text_index: int = 0
var max_text_index:int = 0
var dialogue_text: String = ""

var choices_menu: ChoicesMenu = null
var enter_to_continue: bool = true

func _ready():
	DP.prepare_file("res://dialogues/intro.txt")

func _process(delta):
	if enter_to_continue and Input.is_action_just_pressed("ui_accept"):
		go_further()
	elif text_index < max_text_index:
		text_index += 1
		DialogueLabel.visible_characters = text_index

func go_further():
	var dialogue_info: DialogueParser.DialogueRV = DP.next()
	if dialogue_info.type == DialogueParser.ReturnType.DIALOGUE:
		update_dialogue(dialogue_info)
	elif dialogue_info.type == DialogueParser.ReturnType.CHOICES:
		choice_menu(dialogue_info.content)
	elif dialogue_info.type == DialogueParser.ReturnType.END:
		end_dialogue()
	else:
		print("err")

func end_dialogue():
	print("You win!")
	enter_to_continue = false

func choice_menu(choices: Array):
	DialogueLabel.text = ""
	NPCLabel.text = ""
	choices_menu = ChoicesMenu.init(Vector2(13, 225), choices, _on_choice_taken)
	enter_to_continue = false
	add_child(choices_menu)

func update_dialogue(dialogue_info: DialogueParser.DialogueRV):
	text_index = 0
	max_text_index = len(dialogue_info.content[0])
	NPCLabel.text = dialogue_info.character_name
	DialogueLabel.visible_characters = 0
	DialogueLabel.text = dialogue_info.content[0]
	
func _on_choice_taken(id: String):
	choices_menu.queue_free()
	DP.choose(id)
	go_further()
	enter_to_continue = true
