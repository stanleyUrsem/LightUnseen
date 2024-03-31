extends TextAnimator

class_name Cutscene
@export var anim : AnimationPlayer
@export var anim_prefix : String
@export var auto_pause : bool
var current_anim_index
var current_anim_done
var current_text_anim_done
@export var paused : bool

signal OnAnimationComplete
signal OnTextAnimate(user)
func _animation_complete():
	super()
	if(auto_pause):
		paused = true
	if(paused):
		return false
	current_text_anim_done = true
	#current_anim_index +=1
	print("%s Text Animation finished" % name)
	
	#if(current_anim_done):
		#_set_anim_text(current_anim_index)
		#current_text_anim_done = false
		#current_anim_done = false
		##OnAnimationComplete.emit()
		#return true
		#anim.play("%s%d" % [anim_prefix,current_anim_index])
func continue_scene():
	if(!current_text_anim_done && current_anim_done && !paused):
		skip()
		return
	
	if(current_text_anim_done && !paused):
		current_anim_index +=1
		_set_anim_text(current_anim_index)
		current_text_anim_done = false
		current_anim_done = false
		OnAnimationComplete.emit()
func empty_text():
	label.text = ""
func skip():
	if(text_tween!= null):
		if(text_tween.is_valid()):
			text_tween.kill()
			label.text = animated_text
			label.modulate.a = 1.0
			_animation_complete()
			return true
		else:
			label.text = ""
	return false	
#func skip():
	#if(skipped):
		#print("already skipped %s" % name)
		#return false
	#if(text_tween!= null && text_tween.is_valid()):
		#if(!skipped):
			#print("Skipping %s" % name)
			#text_tween.kill()
			#skipped = true
		#label.text = animated_text
		##text_tween = get_tree().create_tween()
		##text_tween.tween_method(func(x):
			##label.modulate.a = x
			##,1.0,0.0,.5)
		##text_tween.tween_callback(func():
			##print("Fully skipped %s" % name)
			##animated_text = ""
			##label.text = ""
			##label.modulate.a = 1.0
			##skipped = false
			##_animation_complete()
		##)
		#return true
	#return false
#func resume():
	#paused = false
	#continue_scene()
	#_animation_complete()
func _setup_texts():
	pass
func set_anim_index(index: int):
	#return
	print("wat?")
	current_anim_index = index
func animate_text():
	super()
	OnTextAnimate.emit(self)
	
func animation_finished(x):
	current_anim_done = true
	#if((current_text_anim_done && !paused)):
	#if(!paused):
		#current_text_anim_done = false
		#current_anim_done = false
		#_set_anim_text(current_anim_index)
		#OnAnimationComplete.emit()
			
			#anim.play("%s%d" % [anim_prefix,current_anim_index])
func _ready():
	paused = false
	current_text_anim_done = false
	current_anim_done = false
	current_anim_index = 0
	_setup_texts()
	super()
	#anim.current_animation_changed.connect(func(x):
		#_set_anim_text(current_anim_index)
		#current_text_anim_done = false
		#current_anim_done = false
		#)
	anim.animation_finished.connect(animation_finished)
		#if(current_text_anim_done && !paused):
			##_set_anim_text(current_anim_index)
			#current_text_anim_done = false
			#current_anim_done = false
			##OnAnimationComplete.emit()
			#
			##anim.play("%s%d" % [anim_prefix,current_anim_index])
		#)
	#if(on_ready):
		#anim.play("%s%d" % [anim_prefix,current_anim_index])
