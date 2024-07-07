extends Node2D

@onready var Parser = DP.new()
@onready var DI: DialogueInterpreter = DialogueInterpreter.new()
@onready var DialogueLabel := $DialogueLabel
@onready var NPCLabel := $NPCLabel
@onready var SceneryManager := $SceneryManager

var text_index: int = 0
var max_text_index: int = 0
var dialogue_text: String = ""

var choices_menu: ChoicesMenu = null
var enter_to_continue: bool = true

var current_chapter: int = -1
var chapters: Array[String] = [
	"intro",
	"grandma",
	"talking_head_2"
	] 

func _ready():
	DI.reset(SceneryManager)
	next_chapter()
	
func next_chapter():
	current_chapter += 1
	
	if current_chapter == 2:
		SceneryManager.transition_curtain($SceneryManager/Street, $SceneryManager/Office)
		SceneryManager.play_sound(["footsteps.wav"])
	elif current_chapter == 3:
		SceneryManager.transition_curtain($SceneryManager/Street/Grandma, null)
		SceneryManager.play_sound(["footsteps.wav"])
	
	DI.reset($SceneryManager)
	DI.tokens = Parser.prepare_file("res://dialogues/" + chapters[current_chapter] + ".txt")
	go_further()

func _process(delta):
	if enter_to_continue and Input.is_action_just_pressed("ui_accept"):
		go_further()
	elif text_index < max_text_index:
		text_index += 1
		DialogueLabel.visible_characters = text_index

func go_further():
	var dialogue_info: DialogueInterpreter.DialogueRV = DI.get_next_dialogue()
	if dialogue_info.type == DialogueInterpreter.ReturnType.DIALOGUE:
		update_dialogue(dialogue_info)
	elif dialogue_info.type == DialogueInterpreter.ReturnType.CHOICES:
		choice_menu(dialogue_info.content)
	elif dialogue_info.type == DialogueInterpreter.ReturnType.END:
		end_dialogue()
	else:
		print("err")

func end_dialogue():
	next_chapter()

func choice_menu(choices: Array):
	DialogueLabel.text = ""
	NPCLabel.text = ""
	choices_menu = ChoicesMenu.init(Vector2(13, 225), choices, _on_choice_taken)
	enter_to_continue = false
	add_child(choices_menu)

func update_dialogue(dialogue_info: DialogueInterpreter.DialogueRV):
	text_index = 0
	max_text_index = len(dialogue_info.content[0])
	NPCLabel.text = dialogue_info.character_name
	DialogueLabel.visible_characters = 0
	DialogueLabel.text = dialogue_info.content[0]
	
func _on_choice_taken(id: String):
	choices_menu.queue_free()
	DI.choose(id)
	go_further()
	enter_to_continue = true
	


