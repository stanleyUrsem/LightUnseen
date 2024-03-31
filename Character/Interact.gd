extends Node2D

class_name Interact

@export var cast : ShapeCast2D
@export var secondsPerResource : float
@export var animTree : AnimationTree
@export var movement : SionMovement
@export var data : AbilityData
@onready var eventsManager : EventsManager = $"/root/MAIN/EventsManager"
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"
var timerTween : Tween
var interacting : bool
var interaction_unlocked : bool
var hotkeyManager : HotkeyManager
func _ready():
	hotkeyManager = get_node("/root/MAIN/HUD/Node2D/H/HotkeyContainer")
	
	interaction_unlocked = saveManager.loaded_data["interaction_unlocked"]
	if(!interaction_unlocked):
		eventsManager.OnToolsPickUp.connect(unlock_tools)
	else:
		hotkeyManager.create_hotkey(data)
func unlock_tools():
	saveManager.add_data("interaction_unlocked",true)
	interaction_unlocked = true
	hotkeyManager.create_hotkey(data)
func update_input():
	if(!interaction_unlocked):
		return
	
	if(Input.is_action_just_pressed("Interact") && !interacting):
		check_collision()
func interact(col,anim_name):
	interacting = true
	if(timerTween!= null):
		timerTween.kill()
		
	movement.stopMovement = true
	var resourceAmount = col.get_meta("resource_amount")
	AnimatorHelper._playanimTreeOneShotFire(animTree,anim_name)
	timerTween = get_tree().create_tween()
	timerTween.tween_interval(resourceAmount * secondsPerResource)
	timerTween.tween_callback(func():
		movement.stopMovement = false
		col.drop_item(on_drop.bind(col,resourceAmount,anim_name))
		)
		
func on_drop(col,resourceAmount,anim_name):
	col.OnPickUp.emit(col,func():
		AnimatorHelper._playanimTreeOneShotAbort(animTree,anim_name)
		interacting = false,
		10.0 * resourceAmount)
#func mine(col):
#
		#
#func harvest(col):
	#interacting = true
	#if(timerTween!= null):
		#timerTween.kill()
		#
	##Crystals
	#var resourceAmount = col.get_meta("resource_amount")
	#AnimatorHelper._playanimTreeOneShotFire(animTree,"Harvest")
	#timerTween = get_tree().create_tween()
	#timerTween.tween_interval(resourceAmount * secondsPerResource)
	#timerTween.tween_callback(func():
		#col.OnPickUp.emit(col,
				#func():
					#AnimatorHelper._playanimTreeOneShotAbort(animTree,"Harvest")
					#interacting = false,
					#10.0 * resourceAmount)
		#)
	#
func check_collision():
	if(cast.is_colliding()):
		for i in cast.get_collision_count():
			var col = cast.get_collider(i)
			if(col.collision_layer == 8):
				interact(col,"Mine")
			if(col.collision_layer == 32):
				#Grass
				interact(col,"Harvest")
