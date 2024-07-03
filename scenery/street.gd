extends Node2D

func grandma_fall():
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property($Grandma, "modulate", Color(255,0,0,0), 4).set_ease(Tween.EASE_IN)

	tween.tween_property($Grandma, "scale", Vector2(1,0), 4).set_ease(Tween.EASE_OUT)
	tween.tween_property($Grandma, "position", Vector2(100,268), 8).set_ease(Tween.EASE_OUT)
