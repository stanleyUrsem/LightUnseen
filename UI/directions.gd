extends Area2D

@export var control : Control
@export var fade_curve : Curve
@export var scale_curve : Curve
var enable_tween : Tween


func on_body_enter(body):
	
	if(enable_tween != null):
		enable_tween.kill()
	enable_tween = get_tree().create_tween()
	enable_tween.tween_method(set_control,0.0,1.0,0.5)

func set_control(x):
	fade_control(x)
	scale_control(x)

func fade_control(x):
	control.modulate.a = fade_curve.sample(x)

func scale_control(x):
	control.scale = Vector2.ONE *  scale_curve.sample(x)
	
func on_body_exit(body):
	
	if(enable_tween != null):
		enable_tween.kill()
	enable_tween = get_tree().create_tween()
	enable_tween.tween_method(set_control,1.0,0.0,0.5)
