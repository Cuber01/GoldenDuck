extends Node2D
class_name BuiltinLib

@onready var TransitionFade: ColorRect = $TransitionFade
@onready var TransitionCurtain: ColorRect = $TransitionCurtain 
@onready var audio: AudioStreamPlayer = $AudioPlayer

var item_handle = null

const ITEM_SCENE = preload("res://scenery/item.tscn")
const DOCUMENTATION_TEXTURE = preload("res://assets/documentation.png")

var initialized = false

func transition_fade_out():
	var tween = create_tween()
	tween.tween_property(TransitionFade, "color", Color(0,0,0,0), 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func transition_fade_in():
	var tween = create_tween()
	tween.tween_property(TransitionFade, "color", Color(0,0,0,1), 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)

func transition_curtain():
	var tween = create_tween()
	tween.tween_property(TransitionCurtain, "position", Vector2(0,0), 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(TransitionCurtain, "position", Vector2(200,0), 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_delay(1)
	TransitionCurtain.position = Vector2(-200, 0)

func tvguy_change_pose():
	var sprite: AnimatedSprite2D = $Office/TVGuy
	
	if sprite.animation == "default":
		sprite.play("explaining")
	else:
		sprite.play("default")
	
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.05, 1.05), 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_IN)

func grandma_fall():
	var sprite: Sprite2D = $Street/Grandma
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(sprite, "modulate", Color(255,0,0,0), 4).set_ease(Tween.EASE_IN)

	tween.tween_property(sprite, "scale", Vector2(1,0), 4).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "position", Vector2(100,268), 8).set_ease(Tween.EASE_OUT)

func duck_disappear():
	var sprite: Sprite2D = $Item
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(0,0), 4).set_ease(Tween.EASE_OUT)

func item_pickup():
	audio.volume_db = 0
	audio.stream = load("res://assets/sounds/pickup.wav")
	audio.play()
	
	var tween = create_tween()
	tween.tween_property(item_handle, "position", Vector2(100,300), 1).set_ease(Tween.EASE_OUT)
	await tween.finished
	item_handle.queue_free()

func spawn_item(args):
	var item: String = args[0]
	var item_scn = ITEM_SCENE.instantiate()
	
	if item == "documentation":
		item_scn.texture = DOCUMENTATION_TEXTURE
	elif item == "newspaper":
		pass
		
	item_scn.position = Vector2(100, -100)
	item_handle = item_scn
	add_child(item_scn)
	var tween = create_tween()
	tween.tween_property(item_scn, "position", Vector2(100,100), 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

func play_sound(args):
	var sound: String = args[0]
	audio.volume_db = 0
	audio.stream = load("res://assets/sounds/" + sound)
	audio.play()

func stop_playing_sound():
	var tween = create_tween()
	tween.tween_property(audio, "volume_db", -80, 4)
