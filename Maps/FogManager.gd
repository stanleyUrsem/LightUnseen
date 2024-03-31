extends Node2D

@export var mats : Array[Material]
@export var duration: float
@onready var cameraZoom : CameraZoom = $/root/MAIN/CameraZoom
@onready var worldEnvo : WorldEnvironment = $/root/MAIN/WorldEnvironment
@export var heightToZoom : Dictionary
@export var alpha : float
@export var curve : Curve

var tween : Tween
var currentHeight : int
var saved_position : Vector2
var entry_position : Vector2
var exit_position : Vector2
var body_position : Vector2
var new_height : int
var change_elevation : bool
var exit_body
var max_distance : float
var current_distance : float
func _ready():
	setup()

func setup():
	currentHeight = 0
	for mat in mats:
		mat.set_shader_parameter("height", currentHeight)
		mat.set_shader_parameter("new_height", currentHeight)
		mat.set_shader_parameter("transition", 0.0)

func add_fog_data(area,old,new):
	area.body_entered.connect(save_position_on_enter.bind(old,new,
	area.get_node("Col")))
	area.body_exited.connect(start_elevation_change_on_exit)
func in_between(a,b, dist):
	return a <= b + dist && a >= b - dist

func save_position_on_enter(body, old_height,p_new_height,col_node):
	print("Entering ","Body:",body.name)
	
	#var col_string = String(col)
	#var col_node = get_node(col_string)
	var area = col_node.get_parent()
	exit_position = area.global_position
	#entry_position = area.to_global(col_node.shape.size)
	entry_position = area.get_child(1).global_position
	currentHeight = old_height
	new_height = p_new_height
	for mat in mats:
		mat.set_shader_parameter("height", currentHeight)
		mat.set_shader_parameter("new_height", new_height)
	exit_body = body

	change_elevation = true
	

func start_elevation_change_on_exit(body):
	print("Elevation change done")
	change_elevation = false
	for mat in mats:
		print("Height: ",mat.get_shader_parameter("height"));
		print("New Height: ",mat.get_shader_parameter("new_height"));
		print("Transition: ",mat.get_shader_parameter("transition"));
	return


func _process(delta):
	if(!change_elevation):
		return
	body_position = exit_body.global_position 
	current_distance = (body_position.y -  (entry_position).y)

	alpha = remap(body_position.y,exit_position.y,entry_position.y,0.0,1.0)
	alpha = clamp(alpha,0.0,1.0)
	for mat in mats:
		mat.set_shader_parameter("transition",curve.sample(alpha))
	var zoom = lerp(heightToZoom[currentHeight].x,heightToZoom[new_height].x,alpha)
	var bloom = lerp(heightToZoom[currentHeight].y,heightToZoom[new_height].y,alpha)
	cameraZoom.zoom(zoom)
	worldEnvo.environment.glow_bloom = bloom
	
func set_shader_value(value: float):
	for mat in mats:
		mat.set_shader_parameter("transition", value)
		if(value >= 1.0):
			mat.set_shader_parameter("height", currentHeight)
			mat.set_shader_parameter("transition", 0.0)
		
func set_fog_manually(alpha):
	for mat in mats:
		mat.set_shader_parameter("transition",curve.sample(alpha))
	var zoom = lerp(heightToZoom[currentHeight].x,heightToZoom[new_height].x,alpha)
	var bloom = lerp(heightToZoom[currentHeight].y,heightToZoom[new_height].y,alpha)
	cameraZoom.zoom(zoom)
	worldEnvo.environment.glow_bloom = bloom
		
