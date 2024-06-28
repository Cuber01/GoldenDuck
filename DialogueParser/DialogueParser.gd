class_name DialogueParser
extends Node

var variables: Dictionary = {}

var last_npc: String
var lines: Array

var line_index = 0

func prepare_file(filepath: String):
	var text: String = FileAccess.open(filepath, FileAccess.READ).get_as_text()
	lines = text.split("\n")

func next() -> Array:
	var dialogue_line: String
	
	while line_index < len(lines):
		var line: String = lines[line_index]

		if len(line) == 0:
			line_index += 1
			return [last_npc, dialogue_line]
		else: dialogue_line += " "
		
		var i: int = 0
		while i < len(line):
			var char: String = line[i]
			
			# Narrator (No character)
			if char == "/":
				dialogue_line[i-1] = "" # Remove space
				last_npc = ""
				i += 1
			# Character
			elif i == 0 and char == char.to_upper() and line[i+1] == line[i+1].to_upper():
				last_npc = ""
				dialogue_line[0] = "" # Remove space
				while char != ":":
					last_npc += char
					i += 1
					char = line[i]
				i += 2 # Ignore the ':' and space
			# Dialogue text
			else:
				dialogue_line += char
				i += 1
				
		line_index += 1
				
	return [null]
