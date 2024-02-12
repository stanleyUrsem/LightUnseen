extends Sprite2D

@export var mouse_handler : MouseHandler
@export var user : Node2D
@export var mat_nodes : Array[Node2D]
var mats : Array[Material]
func _ready():
	for node in mat_nodes:
		mats.append(node.get_material())
#	mats = get_material()
	mouse_handler = get_node("/root/MAIN/Camera2D")

func _process(delta):
	if(user== null):
		return
	var direction = HelperFunctions.get_mouse_direction(user,mouse_handler)
	
	for mat in mats:
		mat.set_shader_parameter("mouse_dir", direction * get_parent().scale)
		
	
func get_mouse_direction()-> Vector2:
	var mousePos = mouse_handler.mouseGlobalPos
	var pos = user.position
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
