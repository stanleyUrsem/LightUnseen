extends Node2D

@export var day : Color
@export var night : Color
@export var enabled : bool

var dayNightManager
func _ready():
	dayNightManager = get_node("/root/MAIN/DayNightManager")
	enabled = dayNightManager.enabled 
	#enabled = false
	
func set_day():
	modulate = day
func set_night():
	modulate = night	
		
func _process(delta):
	if(dayNightManager != null && enabled):
		modulate = lerp(day,night,dayNightManager.get_transition())
