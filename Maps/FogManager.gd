extends Node2D

@export var mat : Material
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
var new_height : int
var change_elevation : bool
var exit_body
var max_distance : float
var current_distance : float
func _ready():
	currentHeight = 0
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
	entry_position = area.to_global(col_node.shape.size)
	exit_position = entry_position - col_node.shape.size
	currentHeight = old_height
	new_height = p_new_height

	mat.set_shader_parameter("height", currentHeight)
	mat.set_shader_parameter("new_height", new_height)
	exit_body = body

	change_elevation = true
	

func start_elevation_change_on_exit(body):
	print("Elevation change done")
	change_elevation = false
	print("Height: ",mat.get_shader_parameter("height"));
	print("New Height: ",mat.get_shader_parameter("new_height"));
	print("Transition: ",mat.get_shader_parameter("transition"));
	return


func _process(delta):
	if(!change_elevation):
		return
	var pos : Vector2 = exit_body.position 
	current_distance = (pos.y -  (entry_position).y)

	alpha = remap(pos.y,exit_position.y,entry_position.y,0.0,1.0)
	mat.set_shader_parameter("transition",curve.sample(alpha))
	var zoom = lerp(heightToZoom[currentHeight].x,heightToZoom[new_height].x,alpha)
	var bloom = lerp(heightToZoom[currentHeight].y,heightToZoom[new_height].y,alpha)
	cameraZoom.zoom(zoom)
	worldEnvo.environment.glow_bloom = bloom
	
func set_shader_value(value: float):
	mat.set_shader_parameter("transition", value)
	if(value >= 1.0):
		mat.set_shader_parameter("height", currentHeight)
		mat.set_shader_parameter("transition", 0.0)
		
	


