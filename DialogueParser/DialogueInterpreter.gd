extends Node
class_name DialogueInterpreter

var tokens = []
var choices: Dictionary = {}
var indentation_level: int = 0
var last_npc: String

class DialogueRV:
	var type: ReturnType = ReturnType.NONE
	var character_name: String = ""
	var content: Array = []

enum ReturnType {
	DIALOGUE,
	CHOICES,
	END,
	NONE
}

var dialogue_line: String

var token
var line: int

var i: int = 0:
	set(value):
		i = value
		token = tokens[i]

func get_next_dialogue() -> DialogueRV:
	print(tokens)
	var rv: DialogueRV = DialogueRV.new()
	
	token = tokens[i]
	while i < len(tokens)-1:
		line = token.line
		
		if token.type == DP.TokenType.INDENT:
			var indent_amount = next()
			if indent_amount != indentation_level:
				var peeked_val = peek()
				while (peeked_val is DP.Token and peeked_val.line == line) or not peeked_val is DP.Token:
					next()
					peeked_val = peek()
		elif token.type == DP.TokenType.JUMP:
			var jump_to = int(next())
			jump(jump_to)
			i -= 1
		elif token.type == DP.TokenType.END:
			rv.type = ReturnType.END
			
			return rv
		elif token.type == DP.TokenType.CHARACTER:
			var npc_name = next()
			var dialogue_line: String
			while peek().type == DP.TokenType.TEXT:
				dialogue_line += skip_next() + " "
			next()
			
			rv.content.append(dialogue_line)
			rv.character_name = npc_name
			rv.type = ReturnType.DIALOGUE
			return rv
		elif token.type == DP.TokenType.CHOICE:
			var choice: String = skip_next()
			choices[choice] = line+1
		elif token.type == DP.TokenType.TEXT:
			print("Text — is it useless?")
		elif token.type == DP.TokenType.EMPTY_LINE:
			print("Empty line — is it useless?")
		
		i += 1
	return null

func jump(jump_to: int):
	var j: int = 0
	while j < len(tokens)-1:
		var token = tokens[j]
		
		if token is DP.Token:
			if token.line == jump_to:
				i = j
				break
				
		j += 1

func skip_next():
	i += 2
	return token

func next():
	i += 1
	return token

func peek():
	return tokens[i+1]
