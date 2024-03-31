extends Node2D
@export var main : MapSwitcher
@export var fade_curve : Curve
@export var duration : float
var blackscreen
var tween_fade : Tween
func _ready():
	main.OnMapLoaded.connect(setup)

func setup():
	blackscreen = get_node("/root/MAIN/HUD/Node2D/Blackout")
	
	if(tween_fade != null):
		tween_fade.kill()
		
	tween_fade = get_tree().create_tween()
	tween_fade.tween_method(func(x):
		blackscreen.material.set_shader_parameter("t",
		fade_curve.sample(x)),
		1.0,0.0,duration)
