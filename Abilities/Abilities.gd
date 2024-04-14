extends Node2D

class_name AbilityManager

@export var charMovement : CharacterMovement
@export var abilityData : Array[AbilityData]
@export var abilitySpawns : Array[Marker2D]
@export var mouseHandler : MouseHandler
@export var left : Node2D
@export var right : Node2D
@export var timer_duration : float
@export var movement_duration : float
@export var dist_multiplier : float
@export var move_curve : Curve
@export var statsHolder : StatsHolder
@export var mouse_direction : Vector2
@export var interaction : Interact
@onready var eventsManager : EventsManager = $"/root/MAIN/EventsManager"
@onready var cameraEffects : CameraEffects = $"/root/MAIN/CameraEffects"
var amount_abilities : int
var abilities : Dictionary
var current_combo : Array[String]
var timer : float
var timer_started : bool
var move_player_tween : Tween
var prng : PRNG
var hotkeyManager : HotkeyManager
var current_hold
var animChar: AnimatableCharacter:
	get: 
		return charMovement.animChar
var loaded : bool = false
var enabled : bool

func _ready():
	prng = PRNG.new(93132)
	hotkeyManager = get_node("/root/MAIN/HUD/Node2D/H/V/HotkeyContainer")
	setupAbilities()
	mouseHandler = get_parent().get_parent().get_node("Camera2D")
	current_hold = null
	print(mouseHandler)
	loaded = true
	enabled = true

func setupAbilities():
	hotkeyManager.destroy_current_hotkeys()
	for i in abilityData.size():
		var a = Ability.new()
		var data = abilityData[i]
		a.setup(data,left,right)
		abilities[data.hotkey_index] = a
		hotkeyManager.create_hotkey(data)
func add_data(data):
	abilityData.append(data)
func add_ability(data):
	var a = Ability.new()
	a.setup(data,left,right)
	abilities[data.hotkey_index] = a
	hotkeyManager.create_hotkey(data)
func set_enabled(enable:bool):	
	enabled = enable
func _physics_process(delta):
	if(!enabled):
		return
	interaction.update_input(delta)
	useAbilities()
	if(timer > 0):
		timer -= (delta)
	
	if(timer <= 0 && timer_started):
		print("Time is up")
		timer_started = false
		timer = 0
		current_combo.clear()
	
func to_degrees(radians) -> float:
	return radians * 180.0 / PI;
	
func get_angle(point, center)-> float:
	var delta = (point - center).normalized()
	var relPoint = delta
	var rad = atan2(relPoint.y, relPoint.x)
	var degrees = to_degrees(rad)
	print("Angle: %d\nRad: %d\nDelta: %v" % [degrees,rad,delta])
	return degrees
func set_velocity(x,velocity):
	var new_velocity = Vector2.ZERO.lerp(velocity,move_curve.sample(x))
	print("\nx: %f\nvelo: %v\nnew velo: %v" % [x,velocity,new_velocity])
	charMovement.apply_velocity(new_velocity)

func move_player(dist: float, direction: Vector2):
	var mouse_direction = mouseHandler.mouseGlobalPos - charMovement.global_position
	if(move_player_tween != null && move_player_tween.is_valid()):
		move_player_tween.kill()
		return;
		
		
	var dir = snapped(mouse_direction.normalized() * direction, Vector2(0.15,0.15))
	print("Direction: ",dir)	
	move_player_tween = get_tree().create_tween()
	#rollTween.set_trans(Tween.TRANS_EXPO)
	#rollTween.set_ease(Tween.EASE_IN_OUT )
	move_player_tween.tween_method(set_velocity.bind(dir * dist* dist_multiplier),0.0,1.0,movement_duration)
	#move_player_tween.tween_callback(reset_velocity)
	#charMovement._setVelocity(direction.normalized() * dist)
	
#func test_mouse():
#	var root = get_parent()
#	lineMarker.set_point_position(0,root.to_global(root.position))
#	lineMarker.set_point_position(1, _GetMouseDirection(root))

func rotate_sprite_to_mouse(path: String, offset_degrees: float):
	var sprite = get_parent().get_node(path)
	sprite.rotation_degrees = get_angle(get_parent().global_position,
	mouseHandler.mouseGlobalPos) + offset_degrees
	if(charMovement.animChar.turnCurrent > 0):
		sprite.rotation_degrees += offset_degrees
	
func reset_rotation(path:String):
	var sprite = get_parent().get_node(path)
	sprite.rotation = 0.0
		
		
		
func check_for_combo(combo_array) -> bool:
	#if(combo_array.size() == current_combo.size()):
	var same_strings = 0
	for i in current_combo.size():
		if(i >= combo_array.size()):
			break
		if(current_combo[i] == combo_array[i]):
			same_strings += 1
			
	if(same_strings == combo_array.size()):
		print("Combo succeeded")
		current_combo.clear()
		return true
		
	var start_index = 0
	#Set index to on going size
	#if(current_combo.size() > 0):
	start_index = current_combo.size()
	if((combo_array.size()) <= start_index):
		return false
	
		
	#Go for start index
	if(Input.is_action_just_pressed(combo_array[start_index])):
		current_combo.append(combo_array[start_index])
		print("%s is pressed\nCount:%d" % [combo_array[start_index],start_index])
		timer = timer_duration
		timer_started = true
		#combo_timer.start()
	return false
func create_ability(data : AbilityData,activate = true):
	print(data.animName)
	var toggle_suffix = ""
	var toggle_value : int = 0
	if(data.hold):
		current_hold = data
	if(data.toggle):
		toggle_suffix = "Off" if hotkeyManager.toggles[data.displayName] else "On"
		toggle_value = 0 if hotkeyManager.toggles[data.displayName] else 1
		hotkeyManager.toggle_pressed.emit(data.displayName)
		
	var blend_add_value = data.value + toggle_value if activate else 0
	var one_shot = data.oneShot if activate else AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	
	match(data.animNodeType):
		data.AnimationNodeType.ONESHOT:
			AnimatorHelper._playanimTreeOneShot(animChar._animator,
			data.animName + toggle_suffix,one_shot)
		data.AnimationNodeType.BLEND:
			AnimatorHelper._playanimTreeBlend2D(animChar._animator,
			data.animName,blend_add_value)
		data.AnimationNodeType.ADD:
			AnimatorHelper._playanimTreeAdd2D(animChar._animator,
			data.animName,blend_add_value)
	if(data.animOnly):
		eventsManager.OnSkillUsed.emit(data)
		if(data.zoom > 0.0 || data.zoom < 0.0):
			cameraEffects.zoom_in_out(data.zoom,data.zoom_duration)
		if(data.shake_force > 0.0):
			cameraEffects.shake(data.shake_force,data.shake_duration)
	
func enough_mana(data : AbilityData):
	#print("\nMana: %d\nMana needed: %d"  % [statsHolder.stats.mana ,
	 #data.mana])
	return statsHolder.stats.mana > abs(data.mana)
func useAbilities():
	
	if(current_hold != null):
		var keybind = current_hold.keyBinds[current_hold.hold_index]
		if(Input.is_action_just_released(keybind) || !enough_mana(current_hold)):
			create_ability(current_hold,false)
			current_hold = null
	
	for key in abilities:
		var ability = abilities[key]
		var data = ability.data
		var combo_check = ability.isSetup && check_for_combo(data.keyBinds)
		
		if(combo_check && enough_mana(data)):
			create_ability(data)
			#if(data.useOneShot):
			#else:


			


func useAbility(index: int, locationIndex: int, direction: Vector2):
	print("Using ability %d %s" % [index,abilities[index].data.displayName])
	#if(abilityData[index].toggle):
	var data = abilities[index].data as AbilityData
	if(!enough_mana(data)):
		if(data.toggle):
			create_ability(data,false)
		return
		
	eventsManager.OnSkillUsed.emit(data)
	
	if(data.zoom > 0.0 || data.zoom < 0.0):
		cameraEffects.zoom_in_out(data.zoom,data.zoom_duration)
	if(data.shake_force > 0.0):
		cameraEffects.shake(data.shake_force,data.shake_duration)
	
	var location = abilitySpawns[locationIndex]
	abilities[index].use(get_tree().root.get_child(0),
	location.global_position,
	get_parent(), mouseHandler, direction,prng
	,abilitySpawns[0].get_parent().rotation_degrees)

#func createAbilities(data, ability):
#	if(data.useOneShot):
#		AnimatorHelper._playanimTreeOneShot(animChar._animator,
#		data.animName,data.oneShot)
#	else:
#		AnimatorHelper._playanimTreeBlend2D(animChar._animator,
#		data.animName,data.value)
#	ability.use(get_tree().root.get_child(0))

