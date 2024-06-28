extends Node2D

@onready var DP: DialogueParser = DialogueParser.new()
@onready var DialogueLabel = $DialogueLabel
@onready var NPCLabel = $NPCLabel

var text_index: int = 0
var max_text_index:int = 0
var dialogue_text: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	DP.prepare_file("res://dialogues/intro.txt")
	var dialogue_info: Array = DP.next()
	update_dialogue(dialogue_info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var dialogue_info: Array = DP.next()
		update_dialogue(dialogue_info)
	elif text_index < max_text_index:
		text_index += 1
		DialogueLabel.visible_characters = text_index
		

func update_dialogue(dialogue_info: Array):
	text_index = 0
	max_text_index = len(dialogue_info[1])
	NPCLabel.text = dialogue_info[0]
	DialogueLabel.visible_characters = 0
	DialogueLabel.text = dialogue_info[1]
	
	
