extends Node2D

class_name CameraZoom

var cam
var default_zoom
var zoom_tween : Tween


func _ready():
	setup()
func setup():
	cam = get_node("/root/MAIN/Camera2D")
	default_zoom = cam.zoom.x
func zoom(value):
	cam.zoom = Vector2.ONE * value
func zoom_over_time(duration,p_zoom):
	if(zoom_tween != null):
		zoom_tween.kill()
	var old_zoom = cam.zoom
	zoom_tween = get_tree().create_tween()
	zoom_tween.tween_method(zoom,old_zoom.x,p_zoom,duration)
	
