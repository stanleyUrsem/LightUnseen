extends Node2D

class_name CameraEffects

@export var camera2d : Camera2D
@export var zoom_curve : Curve
@export var noise : Noise
var zoom_tween : Tween
var shake_tween : Tween
var old_zoom
var new_zoom
var noise_pos : float
var zooming : bool
func _ready():
	zooming = false

func zoom_in_out(value: float,duration:float):
	if(zoom_tween != null):
		zoom_tween.kill()
	if(!zooming):
		zooming = true
		old_zoom = camera2d.zoom.x
	#if(zooming):
		
	new_zoom = camera2d.zoom.x + value
	zoom_tween = get_tree().create_tween()
	zoom_tween.tween_method(zoom_cam,0.0,1.0,duration)
	zoom_tween.tween_callback(reset_zooming)
func reset_zooming():
	zooming = false
func zoom_cam(value):
	camera2d.zoom = Vector2.ONE * lerp(old_zoom,
	new_zoom,zoom_curve.sample(value))

func shake(force : float, duration : float):

	if(shake_tween!= null):
		shake_tween.kill()
	noise_pos = 0
	shake_tween = get_tree().create_tween()
	shake_tween.tween_method(shake_cam.bind(force),0.0,1.0,duration)
func sinc(x:float,k:float):
	var a = PI*(k*x-1.0)
	return sin(a)/a
	
func shake_cam(value, force):
	noise_pos += value * force
	var shakeness_x = remap(noise.get_noise_1d(noise_pos),0.0,1.0,-1.0,1.0)
	var shakeness_y = remap(noise.get_noise_1d(-noise_pos),0.0,1.0,-1.0,1.0)
	var force_alpha = sinc(value,force)
	#var force_alpha = zoom_curve.sample(value)
	var shakeness = Vector2(shakeness_x,shakeness_y) * force_alpha
	
	camera2d.offset = shakeness * force
