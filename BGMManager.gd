extends Node2D

class_name BGMManager

@export var bgm_in : AudioStreamPlayer
@export var bgm_out : AudioStreamPlayer
@export var volume_min : float
@export var volume_max : float
@export var bgms : Array[AudioStream]
@export var duration: float
@export var alpha : float
@export var alphaX : float
@export var alphaY : float
@export var curveIn : Curve
@export var curveOut : Curve
@export var pitch_hp_curve : Curve
@export var eventsManager : EventsManager
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"

var tween : Tween
var current_BGM : int
var saved_position : Vector2
var entry_position : Vector2
var exit_position : Vector2
var body_position : Vector2
var new_BGM : int
var change_elevation : bool
var exit_body
var max_distance : float
var current_distance : float
var useY: bool
var killed: bool
func _ready():
	if(saveManager.loaded_data.has("npc_amount_killed")):
		killed = saveManager.loaded_data["npc_amount_killed"] > 0
	if(!killed):
		eventsManager.OnNpcKilled.connect(set_killed)
	setup()
func set_killed(x):
	killed = true
	eventsManager.OnNpcKilled.disconnect(set_killed)
func setup():
	current_BGM = 14 if killed else 0
	bgm_in.stream = bgms[current_BGM]
	bgm_in.play()
func set_bgm_custom(stream : AudioStream):
	bgm_in.stream = stream
	bgm_in.volume_db = curveIn.sample(1.0)
	bgm_out.volume_db = curveOut.sample(1.0)	
	bgm_in.play()
func set_bgm(index):
	bgm_in.stream = bgms[index]
	bgm_in.volume_db = curveIn.sample(1.0)
	bgm_out.volume_db = curveOut.sample(1.0)	
	bgm_in.play()

func add_bgm_data(area,old,new):
	area.body_entered.connect(save_position_on_enter.bind(old,new,
	area.get_node("Col")))
	area.body_exited.connect(start_elevation_change_on_exit)
func in_between(a,b, dist):
	return a <= b + dist && a >= b - dist

func save_position_on_enter(body, old_BGM,p_new_BGM,col_node):
	print("Entering ","Body:",body.name)
	
	var area = col_node.get_parent()
	exit_position = area.global_position
	entry_position = area.get_child(1).global_position
	
	useY = abs(exit_position.y - entry_position.y) > 1.0
	

	current_BGM = old_BGM
	new_BGM = p_new_BGM
		
	exit_body = body
	var old_pos = bgm_in.get_playback_position()
	var in_old_pos = 0.0
	if(bgm_out.playing):
		in_old_pos = bgm_out.get_playback_position()
	if(bgm_in.stream != bgms[new_BGM]):
		bgm_in.stream = bgms[new_BGM]
		bgm_in.play(in_old_pos)
	if(bgm_out.stream != bgms[current_BGM]):
		bgm_out.stream = bgms[current_BGM]
		bgm_out.play(old_pos)
	change_elevation = true
	

func start_elevation_change_on_exit(body):
	print("Music change done")
	change_elevation = false
	return

func set_pitch(x):
	bgm_in.pitch_scale = pitch_hp_curve.sample(x)
	bgm_out.pitch_scale = pitch_hp_curve.sample(x)
func _process(delta):
	if(!change_elevation):
		return
	body_position = exit_body.global_position 
	current_distance = (body_position.y -  (entry_position).y)

	alphaY = remap(body_position.y,exit_position.y,entry_position.y,0.0,1.0)
	alphaX = remap(body_position.x,exit_position.x,entry_position.x,0.0,1.0)
	alpha = alphaY if useY else alphaX
	alpha = clamp(alpha,0.0,1.0)
	#var transition = curve.sample(alpha)
	bgm_in.volume_db = curveIn.sample(alpha)
	bgm_out.volume_db = curveOut.sample(alpha)
	#for mat in mats:
		#mat.set_shader_parameter("transition",curve.sample(alpha))
	

		
	


