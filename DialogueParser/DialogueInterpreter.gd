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

func next() -> DialogueRV:
	return null
	#var rv: DialogueRV = DialogueRV.new()
	#
	#var i: int = 0
	#while i < len(tokens)-1:
		#if type == TokenType.INDENT:
			#return "[INDENT " + str(line) + "]"
		#elif type == TokenType.JUMP:
			#return "[JUMP " + str(line) + "]" 
		#elif type == TokenType.END:
			#return "[END " + str(line) + "]" 
		#elif type == TokenType.CHARACTER:
			#return "[CHARACTER " + str(line) + "]"
		#elif  type == TokenType.CHOICE:
			#return "[CHOICE " + str(line) + "]" 
		#elif type == TokenType.TEXT:
			#return "[TEXT " + str(line) + "]" 
		#elif type == TokenType.EMPTY_LINE:
			#return "[EMPTY_LINE " + str(line) + "]"
		#
		#i += 1

