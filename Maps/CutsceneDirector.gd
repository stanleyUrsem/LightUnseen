extends Node

class_name CutsceneDirector
@export var auto_play : bool
@export var cutscenes : Array[Cutscene]
@export var text_animations : Array[bool]
@export var animations : Array[String]
@export var anim : AnimationPlayer
@export var area_auto_play : Area2D
@export var manual_destroy : bool
#@onready var playerTransformer : PlayerTransformer = $"/root/MAIN/PlayerTransformer"
#@onready var sceneManager : SceneManager = $"/root/MAIN/SceneManager"
var playerTransformer : PlayerTransformer
var sceneManager : SceneManager 
var current_index
var skipping : bool
var skip_count : int
var current_scene : Cutscene
var paused : bool
var skipped : bool
var dayNightManager
var camZoom
func _ready():
	skip_count = 0
	playerTransformer  = get_node_or_null("/root/MAIN/PlayerTransformer")
	camZoom  = get_node_or_null("/root/MAIN/CameraZoom")
	sceneManager  = get_node_or_null("/root/MAIN/SceneManager")
	paused = false
	skipped = false
	dayNightManager = get_node_or_null("/root/MAIN/DayNightManager")
	print("Setting up director: %s" % name)
	for scene in cutscenes:
		scene.OnTextAnimate.connect(set_scene)
	anim.animation_finished.connect(func(x):
		if(current_scene!= null && current_scene.label.text.length() <= 1 &&\
		 current_scene.current_text_anim_done):
			skip_anim()
		elif(current_scene == null):
			skip_anim()
		)	
	setup()
func set_zoom(zoom : float):
	camZoom.zoom_over_time(0.5,zoom)
func set_day():
	dayNightManager.OnDay.emit()
func set_night():
	dayNightManager.OnNight.emit()	
func set_scene(scene):
	print("Setting scene: %s" % scene.name)
	if(current_scene != null):
		current_scene.empty_text()
	
	current_scene = scene
	if(skipped):
		current_scene.skip()

func setup():
	skipping = false
	#hotkeyManager.anything_pressed.connect(skip)
	current_index = 0 
	for cutscene in cutscenes:
		cutscene.OnAnimationComplete.connect(transition)
	if(area_auto_play != null):
		area_auto_play.body_entered.connect(play_scene_on_trigger.bind(self))
	if(auto_play):
		transition()
	#AnimatorHelper._playanimTreeOneShotFire(animTree,
	#"OneShot %d" % current_index)
func togglePlayerMovement(toggle:bool):
	playerTransformer.active_form.stopMovement = !toggle
func unparent_player():
	if(playerTransformer.active_form == null):
		return
	playerTransformer.active_form.disable_follow()
	#playerTransformer.active_form.reparent(playerTransformer.get_parent())
func unparent_child_object(p_object : String):
	var node = get_node(p_object)
	var parent = get_parent().get_parent()
	node.reparent(parent)
func reparent_player(p_parent : String,p_offset : Vector2):
	var node = get_parent().get_node(p_parent)
	playerTransformer.active_form.enable_follow(node,p_offset)
	#playerTransformer.active_form.position = p_offset
func pass_out_player():
	var death_transition = get_node("/root/MAIN/DeathTransition")
	death_transition.on_pass_out()
func pause():
	paused = true
func resume(x=null):
	paused = false
	transition()
func play_scene_on_trigger(body,scene):
	if(sceneManager!= null):	
		sceneManager.new_scene(scene)
func play_scene():
	if(sceneManager!= null):	
		sceneManager.new_scene(self)
func _physics_process(delta):
	var is_visible = get_parent().visible
	if(Input.is_action_just_pressed("talk") && is_visible):
		skip()
func skip_anim(x=""):
	if(anim == null):
		return
	print_stack()
	print("\nindex: %d\nsize: %d" % [current_index, animations.size()])
	if(anim.current_animation == "" &&\
	 current_scene == null):
		if(current_index >= animations.size()):
			print("Transitioning to end")
			transition()
		if(current_index <  animations.size() &&\
		 text_animations[current_index-1] == false):
			print("Transition caused by no text")
			transition()
		return
	#(current_index < animations.size() && text_animations[current_index] == false)):
		#transition()
	var length = anim.current_animation_length
	var pos = anim.current_animation_position
	var diff = length - pos
	if(diff > 0.0):
		#anim.pause()
		#anim.seek(length,true)
		anim.advance(diff)
		#if( current_scene != null):
			#current_scene.animation_finished("")
		#else:
			#transition()
		#transition()
		#anim.advance(diff-(diff*.01))
		#anim.play()
	else:
		transition()
		print("Difference is zero")
		
	skip_count = 0
func skip():
	if(skipping):
		return
	var text_active = current_scene != null
	if( text_active && current_scene.paused):
		return
	skipping = true
	
	print("anim: %s\n active: %s\n scene: %s" % \
	[anim.current_animation,text_active,current_scene])
	
	if(anim.current_animation == "" && text_active):
		current_scene.continue_scene()
		skipping = false
		return
	#skip_count += 1
	#if(skip_count == 1):

	if(text_active):
		current_scene.skip()
	skip_anim()
	skipped = true
	#if(skip_count == 1 && text_active):
		#print("skipped cutscene: %d" % current_scene.current_anim_index)
		#current_scene.skip()
		#for cutscene in cutscenes:
			#if(cutscene.skip() == true):
				#break
				
	#if(skip_count == 2):
		#print("Skipping animation")
		#skip_anim()
	#transition()
	skipping = false
func transition():
	print("\nTransition")
	print_stack()
	#AnimatorHelper._playanimTreeOneShotAbort(animTree,
	#"OneShot %d" % current_index)
	#
	if(paused):
		return
		
	if(current_scene != null):
		current_scene.empty_text()
		
	current_scene = null
	skipped = false
	if(current_index >= animations.size() ):
		print("Animation fully done")
		if(sceneManager!= null):
			sceneManager.add_played_scene(self.name)
		if(area_auto_play != null):
			area_auto_play.body_entered.disconnect(play_scene_on_trigger)
			if(!manual_destroy):
				area_auto_play.queue_free.call_deferred()
		if(!manual_destroy):
			anim.get_parent().queue_free.call_deferred()
		#call_deferred("queue_free")
		return
	#print_stack()
	print("%s\nnew anim: %s" % [name,animations[current_index]])
	skip_count = 0
	anim.play(animations[current_index])
	current_index += 1
	#
	#AnimatorHelper._playanimTreeOneShotFire(animTree,
	#"OneShot %d" % current_index)





