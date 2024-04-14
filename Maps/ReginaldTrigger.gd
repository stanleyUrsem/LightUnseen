extends Area2D
@export var reginald : Node2D
@export var reginald_layer_values : Array[int]
@export var bgm_index : int
@export var scene_name : String
var sceneManager : SceneManager
var bgmManager : BGMManager
var saveManager : SaveManager
var eventsManager : EventsManager
var is_setup : bool
func _ready():
	sceneManager = get_node("/root/MAIN/SceneManager")
	bgmManager = get_node("/root/MAIN/BGMManager")
	saveManager = get_node("/root/MAIN/SaveManager")
	eventsManager = get_node("/root/MAIN/EventsManager")
	is_setup = false
	eventsManager.OnDeath.connect(reset_mask)

func reset_mask():
	if(is_setup):
		if(reginald == null):
			return
		reset_fight()
		set_collision_mask_value(5,true)
		set_collision_mask_value(8,true)
func _on_body_entered(body):
	if(sceneManager.already_played_scene(scene_name)):
		setup_fight()
		set_collision_mask_value(5,false)
		set_collision_mask_value(8,false)
func reset_fight():
	var ai = reginald.get_node("AI")
	ai.ai_enabled = false
	reginald.visible = false	
	var body = reginald.get_node("StaticBody2D")
	for val in reginald_layer_values:
		reginald.set_collision_layer_value(val,false)
		body.set_collision_layer_value(val,false)
	
func setup_fight():
	if(reginald == null):
		return
	reginald.visible = true
	var body = reginald.get_node("StaticBody2D")
	for val in reginald_layer_values:
		reginald.set_collision_layer_value(val,true)
		body.set_collision_layer_value(val,true)
	var ai = reginald.get_node("AI")
	ai.ai_enabled = true
	bgmManager.set_bgm(bgm_index)
	is_setup = true
