class_name DP
extends Node

var lines: PackedStringArray
var line_index := 0
var tokens: Array[Variant] = []

enum TokenType {
	INDENT,
	JUMP,
	END,
	CHARACTER,
	CHOICE,
	END_CHOICE,
	INDENT_JUMP,
	CALL
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
		elif type == TokenType.END_CHOICE:
			return "[END_CHOICE " + str(line) + "]" 
		elif type == TokenType.INDENT_JUMP:
			return "[INDENT_JUMP " + str(line) + "]"
		elif type == TokenType.CALL:
			return "[CALL " + str(line) + "]"

func prepare_file(filepath: String):
	var text: String = FileAccess.open(filepath, FileAccess.READ).get_as_text()
	lines = text.replace("\n", " \n").split("\n", true)
	return parse_file()

var ch: String = ""
var line: String
var i: int = 0:
	set(value):
		i = value
		ch = line[i]

func parse_file():
	while line_index < len(lines):
		line = lines[line_index]
		
		if not(line == "" or line == " "):
			i = 0
		
		while i < len(line):
			ch = line[i]

			if ch == "\t":
				var k: int = 1
				while line[i+k] == "\t":
					k += 1
				i += k-1
				emit_token(TokenType.INDENT)
				emit_token(k, true)
				
			# Narrator (No character)
			elif ch == "/":
				i += 1
				if ch == "/":
					emit_token(TokenType.CHARACTER)
					emit_token("")
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
					emit_token(int(jump_to)-1, true)
					break
				elif keyword == "END":	
					emit_token(TokenType.END)
					break
				elif keyword == "ENDCHOICE":
					emit_token(TokenType.END_CHOICE)
					break
				elif keyword == "INDJUMP":
					i += 1 # skip space
					var indent_change: String = ""
					while ch.is_valid_float():
						indent_change += ch
						i += 1
					i += 1 # skip space
					var jump_to: String = ""
					while ch.is_valid_float():
						jump_to += ch
						i += 1
					emit_token(TokenType.INDENT_JUMP)
					emit_token(int(indent_change), true)
					emit_token(int(jump_to)-1, true)
					break
				elif keyword == "CALL":
					i += 1 # skip space
					var func_name = ""
					while ch != " " or i > len(line):
						func_name += ch
						i += 1
					
					var args = []
					var current_arg = ""
					while i > len(line):
						i += 1
						if ch == " ":
							args.append(current_arg)
						else:
							current_arg += ch
						
					
					args.append(current_arg)
					emit_token(TokenType.CALL)
					emit_token(func_name)
					emit_token(len(args), true)
					for a in args:
						emit_token(a)
					break
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
				break

			else: 
				var dialogue: String
				while i < len(line)-1:
					dialogue += ch
					i += 1
				#emit_token(TokenType.TEXT)
				emit_token(dialogue)
				break
			
			i += 1
				
		line_index += 1
	return tokens

func emit_token(value, passing_int=false):
	if value is TokenType and not passing_int:
		var token: Token = Token.new()
		token.type = value
		token.line = line_index
		tokens.append(token)
	else:
		tokens.append(value)
