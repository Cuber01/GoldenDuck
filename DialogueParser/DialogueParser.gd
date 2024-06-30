class_name DialogueParser
extends Node

var lines: Array
var line_index = 0
var tokens = []

enum TokenType {
	INDENT,
	JUMP,
	END,
	CHARACTER,
	CHOICE,
	TEXT,
	EMPTY_LINE
}

class Token:
	var type: TokenType
	var line: int
	
	func _to_string():
		if type == TokenType.INDENT:
			return "[INDENT " + str(line) + "]"
		elif type == TokenType.JUMP:
			return "[JUMP " + str(line) + "]" 
		elif type == TokenType.END:
			return "[END " + str(line) + "]" 
		elif type == TokenType.CHARACTER:
			return "[CHARACTER " + str(line) + "]"
		elif  type == TokenType.CHOICE:
			return "[CHOICE " + str(line) + "]" 
		elif type == TokenType.TEXT:
			return "[TEXT " + str(line) + "]" 
		elif type == TokenType.EMPTY_LINE:
			return "[EMPTY_LINE " + str(line) + "]" 

func prepare_file(filepath: String):
	var text: String = FileAccess.open(filepath, FileAccess.READ).get_as_text()
	lines = text.replace("\n", " \n").split("\n", true)
	parse_file()
	print(tokens)

var ch: String = ""
var line: String
var i: int = 0:
	set(value):
		i = value
		ch = line[i]

func parse_file():
	while line_index < len(lines):
		line = lines[line_index]
		
		if line == "":
			emit_token(TokenType.EMPTY_LINE)
		else: 
			i = 0
		while i < len(line):
			ch = line[i]

			if ch == "\t":
				var k: int = 1
				while line[i+k] == "\t":
					k += 1
				emit_token(TokenType.INDENT)
				emit_token(k)
				
			# Narrator (No character)
			elif ch == "/":
				i += 1
				if ch == "/":
					emit_token(TokenType.CHARACTER)
					emit_token("")
					i += 1
				else:
					var npc: String
					while ch != ":":
						npc += ch
						i += 1
					i += 1 # Ignore the ':'
					emit_token(TokenType.CHARACTER)
					emit_token(npc)
				
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
					emit_token(TokenType.JUMP)
					emit_token(int(jump_to)-2)
				elif keyword == "END":	
					emit_token(TokenType.END)
				else:
					print("Unknown Keyword")
			
			elif ch == "-":
				i += 2 # Skip space and '-'
				var choice: String
				while i < len(line)-1:
					choice += ch
					i += 1
				emit_token(TokenType.CHOICE)
				emit_token(choice)

			else: 
				var dialogue: String
				while i < len(line)-1:
					dialogue += ch
					i += 1
				emit_token(TokenType.TEXT)
				emit_token(dialogue)
				break
			
			i += 1
				
		line_index += 1

func emit_token(value):
	if value is TokenType:
		var token: Token = Token.new()
		token.type = value
		token.line = line_index
		tokens.append(token)
	else:
		tokens.append(value)

func is_letter(char: String):
	spb.data_array = char.to_ascii_buffer()
	var ascii_code = spb.get_float() 
	if ascii_code > 97 and ascii_code < 122:
		return true
	return false

func choose(id: String):
	indentation_level += 1
	line_index = choices[id]
	
func jump(line: int):
	pass
