extends Node2D

@onready var sprite = $TVGuy

func change_pose():
	if sprite.animation == "default":
		sprite.play("explaining")
	else:
		sprite.play("default")
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($TVGuy, "scale", Vector2(1.05, 1.05), 0.1)
	
	tween.tween_property($TVGuy, "scale", Vector2(1, 1), 0.1)
