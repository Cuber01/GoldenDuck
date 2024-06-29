class_name DialogueParser
extends Node

var choices: Dictionary = {}
var indentation_level: int = 0

var last_npc: String
var lines: Array

var line_index = 0

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

func prepare_file(filepath: String):
	var text: String = FileAccess.open(filepath, FileAccess.READ).get_as_text()
	lines = text.replace("\n", " \n").split("\n", true)
	print(lines)

var ch: String = ""
var line: String
var i: int = 0:
	set(value):
		i = value
		ch = line[i]

func next() -> DialogueRV:
	var dialogue_line: String
	var rv: DialogueRV = DialogueRV.new()
	
	while line_index < len(lines):
		line = lines[line_index]

		if len(line) <= 1:
			line_index += 1
			rv.character_name = last_npc
			rv.content.append(dialogue_line)
			if rv.type == ReturnType.NONE:
				rv.type = ReturnType.DIALOGUE
			return rv
		
		i = 0
		while i+1 < len(line):
			ch = line[i]
		
			if i == indentation_level:
				# Indent — if it's not our current indent we ignore it
				if ch == "\t":
					var k: int = 1
					while line[i+k] == "\t":
						k += 1
					
					if(indentation_level != k):
						break
				else:
					indentation_level = 0
				
				# Narrator (No character)
				if ch == "/":
					last_npc = ""
				
				# Keyword
				elif ch == "$":
					var keyword: String
					i += 1
					while ch != " " or i > len(line):
						keyword += ch
						i += 1
					i += 2 # skip space
					if keyword == "JUMP":
						var jump_to: String = ""
						while ch.is_valid_float():
							jump_to += ch
							i += 1
						line_index = int(jump_to)
						break
					elif keyword == "END":	
						rv.type = ReturnType.END
						return rv
					else:
						print("error")
				
				# Choice — add and change rv type
				elif ch == "-":
					i += 2 # Skip space and '-'
					var choice: String
					while i < len(line):
						choice += ch
						i += 1
					rv.content.append(choice)
					choices[choice] = line_index+1
					rv.type = ReturnType.CHOICES
					break
				
				elif ch == ch.to_upper() and line[i+1] == line[i+1].to_upper():
					last_npc = ""
					while ch != ":":
						last_npc += ch
						i += 1
					i += 1 # Ignore the ':'
				
			# Ignore tabs
			elif ch == "\t":
				i += 1
				continue
			
			# Add dialogue text
			else: 
				dialogue_line += ch
			
			i += 1
				
		line_index += 1
				
	return rv

func choose(id: String):
	indentation_level += 1
	line_index = choices[id]
	
func jump(line: int):
	pass
