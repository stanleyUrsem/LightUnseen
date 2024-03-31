extends Node


class_name TextAnimator

@export var speed : float
@export var on_ready : bool
@export var label : RichTextLabel
@export var audio_player : AudioStreamPlayer
@export var audio_per_letters : float
var text_tween : Tween
var animated_text: String
var skipped : bool
var anim_texts : Array[String]
func _set_anim_text(index):
	print_stack()
	print("Set anim index: %d" % index)
	if(index >= anim_texts.size()):
		animated_text = ""
		return false
	animated_text = anim_texts[index]
	return true
func _animation_complete():
	label.text = "%s[p][pulse freq=1.0 color=#ffffff40 ease=-2.0]&[/pulse]" % animated_text
func _ready():
	_set_anim_text(0)

func animate_text():
	if(text_tween!= null):
		text_tween.kill()
	var length = animated_text.length()
	var duration = float(length)/speed
	text_tween = get_tree().create_tween()
	text_tween.tween_method(func(x):
		if(fmod(label.text.length(),audio_per_letters) == 0):
			audio_player.play()
		label.text = animated_text.left(lerp(0,length,x))
		,0.0,1.0,duration)
	text_tween.tween_callback(_animation_complete)
	#text_tween.tween_method(func(x):
		#label.modulate.a = x
		#,1.0,0.0,duration)
	#text_tween.tween_callback(func():
		#animated_text = ""
		#label.text = ""
		#label.modulate.a = 1.0
		#_animation_complete()
		#)

