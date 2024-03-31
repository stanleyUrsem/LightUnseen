extends Node2D

@export var minutes_per_day : float
@export var day_night_curve : Curve
var current_time : float 
signal OnNight
signal OnDay
var is_night : bool = false
func _process(delta):
	if(current_time <= 0.0):
		current_time = minutes_per_day * 60.0
	current_time -= delta	
	
func get_transition():
	var t = remap(current_time,0.0,minutes_per_day * 60.0,0.0,1.0)
	var alpha = day_night_curve.sample(t)
	if(alpha >= 1.0 && !is_night):
		is_night = true
		OnNight.emit()
	if(alpha <= 0.0 && is_night):
		is_night = false
		OnDay.emit()
			
	return alpha
