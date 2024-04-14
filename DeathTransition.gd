extends Node2D

class_name DeathTransition

@export var zoom : float
@export var cam_zoom : CameraZoom
@export var map_switcher : MapSwitcher
@export var fogManager : FogManager
@export var fade_curve : Curve
@export var bed_coords : Vector2
@export var doorManager : DoorManager
@export var player_trans : PlayerTransformer
@export var bgmManager : BGMManager
@export var mobSpawner : MobSpawner
var blackscreen : Control
var tween_fade_out : Tween
var tween_fade_in : Tween
var center_img : VBoxContainer
var center_text : RichTextLabel
var completion : VBoxContainer
var hotKeyManager : HotkeyManager
var sceneManager : SceneManager
var is_dead : bool
var passed_out : bool
var old_zoom : float
var completed : bool
func _ready():
	setup()

func setup():
	is_dead = false
	completed = false
	blackscreen = get_node("/root/MAIN/HUD/Node2D/Blackout")
	center_img = get_node("/root/MAIN/HUD/Node2D/Blackout/C")
	completion = get_node("/root/MAIN/HUD/Node2D/Blackout/C3")
	center_text = get_node("/root/MAIN/HUD/Node2D/Blackout/C/Continue")
	hotKeyManager = get_node("/root/MAIN/HUD/Node2D/H/V/HotkeyContainer")
	sceneManager = get_node("/root/MAIN/SceneManager")
	hotKeyManager.anything_pressed.connect(func():
		if(!passed_out && !completed):
			black_screen_fade_out()
		if(completed):
			get_tree().quit()
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
	if(!passed_out && !completed):
		tween_fade_in.tween_method(func(x):
			center_img.modulate.a = x
			,0.0,1.0,.25)
		tween_fade_in.tween_interval(2.0)
		tween_fade_in.tween_method(func(x):
			center_text.modulate.a = x
			,0.0,1.0,.25)
	if(completed):
			tween_fade_in.tween_method(func(x):
				completion.modulate.a = x
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
	if(!passed_out && !completed):
		tween_fade_out.tween_method(func(x):
			center_img.modulate.a = x
			,1.0,0.0,.25)
	if(!completed):
		tween_fade_out.tween_callback(reset_player)
	tween_fade_out.tween_interval(1.5)
	tween_fade_out.tween_method(func(x):
		blackscreen.material.set_shader_parameter("t",fade_curve.sample(x))
		zoom_in_player(x)
		,1.0,0.0,1.5)
	tween_fade_out.tween_callback(func():
			set_ability_enabled(true)
			player_trans.active_form.stopMovement = false)
func set_ability_enabled(enabled:bool):
	var player = player_trans.active_form
	var abilities = player.get_node("Abilities")
	abilities.set_enabled(enabled)		
#Death needs to kill all mobs
func reset_player():
	var is_scene_10 = sceneManager.current_scene != null && sceneManager.current_scene.name == "Scene_10"
	var is_scene_aftermath = sceneManager.current_scene != null && sceneManager.current_scene.name == "Scene_Aftermath"
	
	var game_done = is_scene_10 || is_scene_aftermath
	
	if(!game_done):
		mobSpawner.clear_mobs()
		map_switcher.reset_to_central()
		bgmManager.set_bgm(0)
	
		fogManager.currentHeight = 0
		fogManager.new_height = 0
		fogManager.set_fog_manually(0.0)
	
		if(doorManager == null):
			doorManager = get_node("/root/MAIN/Central/Doors")
		if(passed_out):
			doorManager.on_enter_house(player_trans.active_form,11)
		else:
			doorManager.on_enter_house(player_trans.active_form,2)
	old_zoom = cam_zoom.cam.zoom.x
	set_ability_enabled(false)
	player_trans.active_form.stopMovement = true
	player_trans.active_form.animChar.alive()
	var stats_holder = player_trans.active_form.get_node("Stats")
	stats_holder.reset()
	passed_out = false

func on_pass_out():
	passed_out = true
	on_death(1.0)
func on_complete():
	completed = true
	black_screen_fade(0.0)	
func on_death(emotion_t : float):
	black_screen_fade(emotion_t)
