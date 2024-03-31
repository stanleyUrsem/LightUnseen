extends Node2D

class_name DeathTransition

@export var zoom : float
@export var cam_zoom : CameraZoom
@export var map_switcher : MapSwitcher
@export var fade_curve : Curve
@export var bed_coords : Vector2
@export var doorManager : DoorManager
@export var player_trans : PlayerTransformer
var blackscreen : Control
var tween_fade_out : Tween
var tween_fade_in : Tween
var center_img : CenterContainer
var center_text : RichTextLabel
var hotKeyManager : HotkeyManager
var is_dead : bool
var passed_out : bool
var old_zoom : float
func _ready():
	setup()

func setup():
	is_dead = false
	blackscreen = get_node("/root/MAIN/HUD/Node2D/Blackout")
	center_img = get_node("/root/MAIN/HUD/Node2D/Blackout/C")
	center_text = get_node("/root/MAIN/HUD/Node2D/Blackout/C/Continue")
	hotKeyManager = get_node("/root/MAIN/HUD/Node2D/H/HotkeyContainer")
	
	hotKeyManager.anything_pressed.connect(func():
		if(!passed_out):
			black_screen_fade_out()
		)
func zoom_in_player(t):
	cam_zoom.zoom(lerp(old_zoom, zoom,t))

func black_screen_fade(t_emote):
	if(tween_fade_in != null):
		tween_fade_in.kill()
	old_zoom = cam_zoom.cam.zoom.x
	blackscreen.material.set_shader_parameter("t_a_y",t_emote)
	tween_fade_in = get_tree().create_tween()
	tween_fade_in.tween_method(func(x):
		zoom_in_player(x)
		,0.0,1.0,.75)
	tween_fade_in.tween_method(func(x):
		blackscreen.material.set_shader_parameter("t",fade_curve.sample(x))
		,0.0,1.0,.75)
	#tween_fade_in.tween_callback(reset_player)
	if(!passed_out):
		tween_fade_in.tween_method(func(x):
			center_img.modulate.a = x
			,0.0,1.0,.25)
		tween_fade_in.tween_interval(2.0)
		tween_fade_in.tween_method(func(x):
			center_text.modulate.a = x
			,0.0,1.0,.25)
	tween_fade_in.tween_callback(func(): 
		is_dead = true
		if(passed_out):
			black_screen_fade_out()
		)

func black_screen_fade_out():
	if(!is_dead):
		return
	
	is_dead = false
	if(tween_fade_out != null):
		tween_fade_out.kill()
	tween_fade_out = get_tree().create_tween()
	if(!passed_out):
		tween_fade_out.tween_method(func(x):
			center_img.modulate.a = x
			,1.0,0.0,.25)
	tween_fade_out.tween_callback(reset_player)
	tween_fade_out.tween_interval(1.5)
	tween_fade_out.tween_method(func(x):
		blackscreen.material.set_shader_parameter("t",fade_curve.sample(x))
		zoom_in_player(x)
		,1.0,0.0,1.5)
	tween_fade_out.tween_callback(func():
			player_trans.active_form.stopMovement = false)
		

func reset_player():
	map_switcher.reset_to_central()
	
	if(doorManager == null):
		doorManager = get_node("/root/MAIN/Central/Doors")
	if(passed_out):
		doorManager.on_enter_house(player_trans.active_form,11)
	else:
		doorManager.on_enter_house(player_trans.active_form,2)
	player_trans.active_form.stopMovement = true
	player_trans.active_form.animChar.alive()
	var stats_holder = player_trans.active_form.get_node("Stats")
	stats_holder.reset()
	passed_out = false

func on_pass_out():
	passed_out = true
	on_death(1.0)
	
func on_death(emotion_t : float):
	black_screen_fade(emotion_t)
