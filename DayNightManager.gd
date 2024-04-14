extends Node2D

@export var minutes_per_day : float
@export var world_envo : WorldEnvironment
@export var bcs : Vector3
@export var alpha_night : float
@export var day_night_curve : Curve

var saveManager
var current_time : float 
signal OnNight
signal OnDay
@export var is_night : bool = false
var enabled : bool
signal OnEnabled

func _ready():
	saveManager = get_node("/root/MAIN/SaveManager") as SaveManager
	if(saveManager.loaded_data.has("played_scenes")):
		var played_scenes = saveManager.loaded_data["played_scenes"]
		if(played_scenes.has("Scene_4")):
			enabled = true
			OnEnabled.emit()

func _process(delta):
	return
	if(current_time <= 0.0):
		current_time = minutes_per_day * 60.0
	current_time -= delta	
	
func get_transition():
	var t = remap(current_time,0.0,minutes_per_day * 60.0,0.0,1.0)
	var alpha = day_night_curve.sample(t)
	if(alpha > alpha_night && !is_night):
		is_night = true
		world_envo.environment.adjustment_brightness = bcs.x
		world_envo.environment.adjustment_contrast = bcs.y
		world_envo.environment.adjustment_saturation = bcs.z
		
		OnNight.emit()
	if(alpha <= alpha_night && is_night):
		is_night = false
		world_envo.environment.adjustment_brightness = 1.0
		world_envo.environment.adjustment_contrast = 1.0
		world_envo.environment.adjustment_saturation = 1.0
		OnDay.emit()
			
	return alpha
