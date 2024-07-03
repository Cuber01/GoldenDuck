extends Sprite2D

var rotate = true

func _ready():
	if rotate:
		var tween = create_tween().set_loops(INF).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "rotation_degrees", 12, 2.5)
		tween.tween_property(self, "rotation_degrees", -12, 2.5)
