extends Node2D

@export var mouse_handler : MouseHandler
@export var user : Node
@export var mat_nodes : Array[Node]
var mats : Array[Material]

var mouseGlobalPos : Vector2
var direction : Vector2

func _ready():
	for node in mat_nodes:
		mats.append(node.get_material())
		
func _process(delta):
	mouseGlobalPos = get_global_mouse_position()
	
	if(user== null):
		return
	direction = get_mouse_direction() * get_parent().scale
	
	for mat in mats:
		mat.set_shader_parameter("mouse_dir", direction )
		
	
func get_mouse_direction()-> Vector2:
	var mousePos = mouseGlobalPos
	var pos = user.global_position
#	print(" ")
#	print("Mouse: ",mouse_handler.mouseClickPos)
#	print("Mouse Motion: ",mouse_handler.mouseMotionPos)
#	print("Pos: ",from.position)
#	print("Global Mouse: ",from.to_global(mouse_handler.mouseClickPos as Vector2))
#	print("Global Pos: ",from.to_global(pos))
#	print("Global Parent Pos: ",from.get_parent().to_global(pos))
#	print(" ")
	var direction = mousePos - pos
	return direction.normalized()
