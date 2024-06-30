extends Node


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

var choices: Dictionary = {}
var indentation_level: int = 0

var last_npc: String


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
		while i < len(line)-1:
			ch = line[i]

			# Indent — if it's not our current indent we ignore it
			if i == 0:
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
				
				if keyword == "JUMP":
					i += 1 # skip space
					var jump_to: String = ""
					while ch.is_valid_float():
						jump_to += ch
						i += 1
					line_index = int(jump_to)-2 # -2 cause we increase it later and start at zero
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
				while i < len(line)-1:
					choice += ch
					i += 1
				rv.content.append(choice)
				choices[choice] = line_index+1
				rv.type = ReturnType.CHOICES
				break
			
			elif is_letter(ch) and ch == ch.to_upper() and line[i+1] == line[i+1].to_upper() and ch != "\t":
				last_npc = ""
				while ch != ":":
					last_npc += ch
					i += 1
				i += 1 # Ignore the ':'

			
			# Add dialogue text
			else: 
				if ch != "\t":
					dialogue_line += ch
			
			i += 1
				
		line_index += 1
				
	return rv
