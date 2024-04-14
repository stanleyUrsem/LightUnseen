extends Node

@export var zoom_in_out : float
@export var zoom_duration : float

@export var shake_force : float
@export var shake_duration : float

@onready var cameraEffects : CameraEffects = $"/root/MAIN/CameraEffects"

func use():
	if(zoom_in_out> 0.0 || zoom_in_out < 0.0):
			cameraEffects.zoom_in_out(zoom_in_out,zoom_duration)
	if(shake_force > 0.0):
			cameraEffects.shake(shake_force,shake_duration)
