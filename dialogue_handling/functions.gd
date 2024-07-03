extends Node2D
class_name BuiltinLib

@onready var TransitionFade: ColorRect = $TransitionFade
@onready var TransitionCurtain: ColorRect = $TransitionCurtain

var initialized = false

func transition_fade_out():
	var tween = create_tween()
	tween.tween_property($TransitionFade, "color", Color(0,0,0,0), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func transition_fade_in():
	var tween = create_tween()
	tween.tween_property($TransitionFade, "color", Color(0,0,0,1), 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	
func transition_curtain():
	var tween = create_tween()
	tween.tween_property($TransitionCurtain, "position", Vector2(0,0), 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($TransitionCurtain, "position", Vector2(200,0), 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_delay(1)
	$TransitionCurtain.position = Vector2(-200, 0)
