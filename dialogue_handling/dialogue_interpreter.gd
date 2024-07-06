extends Node
class_name DialogueInterpreter

var tokens: Array[Variant] = []

var choice_trees: Array = [null,null,null,null,null,null,null,null,null,null]
var current_choice_index: int = 0

var indentation_level: int = 0
var last_npc: String

var functions: BuiltinLib

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

var token: Variant = null
var line: int = 0

var i: int = 0:
	set(value):
		i = value
		token = tokens[i]

func reset(SceneryManager: BuiltinLib):
	line = 0
	token = null
	dialogue_line = ""
	last_npc = ""
	indentation_level = 0
	current_choice_index = 0
	tokens = [null]
	choice_trees = [null,null,null,null,null,null,null,null,null,null]
	i = 0
	
	functions = SceneryManager

func get_next_dialogue() -> DialogueRV:
	print(tokens)
	var rv: DialogueRV = DialogueRV.new()
	
	token = tokens[i]
	while i < len(tokens):
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
			var peeked_val = peek()
			while peeked_val is String or peeked_val.type == DP.TokenType.INDENT:
				if not peeked_val is String:
					skip_next()
				else:
					dialogue_line += next() + " "
				peeked_val = peek()
			next()
			
			rv.content.append(dialogue_line)
			rv.character_name = npc_name
			rv.type = ReturnType.DIALOGUE
			return rv
		elif token.type == DP.TokenType.CHOICE:
			var choice: String = next()
			if choice_trees[current_choice_index] == null:
				choice_trees[current_choice_index] = {}
				choice_trees[current_choice_index][choice] = line+1
			else:
				choice_trees[current_choice_index][choice] = line+1
		elif token.type == DP.TokenType.END_CHOICE:
			for c in choice_trees[current_choice_index]:
				rv.content.append(c)
			rv.type = ReturnType.CHOICES
			return rv
		elif token.type == DP.TokenType.INDENT_JUMP:
			var indent_change = int(next())
			var jump_to = int(next())
			jump(jump_to)
			indentation_level -= indent_change
			i -= 1
		elif token.type == DP.TokenType.CALL:
			var func_name = next()
			var amount_of_args = next()
			var args = []
			for a in amount_of_args:
				args.append(next())
			
			var method = Callable(functions, func_name)
			if len(args) > 0:
				method.call(args)
			else:
				method.call()
			
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

func choose(id: String):
	jump(choice_trees[current_choice_index][id])
	indentation_level += 1
	current_choice_index += 1

func skip_next():
	i += 2
	return token

func next():
	i += 1
	return token

func peek():
	return tokens[i+1]
