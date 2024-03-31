extends Control
	
@export var offset_x_range: Vector2
@export var offset_y_range: Vector2
var mouseClickPos : Vector2
var mouseGlobalPos : Vector2
var mouseMotionPos : Vector2
var reso_multi : Vector2

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		mouseClickPos = event.position
		mouseGlobalPos = get_global_mouse_position()
	elif event is InputEventMouseMotion:
		mouseMotionPos =  event.position
		mouseGlobalPos = get_global_mouse_position()
	move_pos()


func move_pos():
	reso_multi.x =    size.x / 640.0
	reso_multi.y =    size.y / 360.0
	
	var offset_x = offset_x_range * reso_multi.x
	var offset_y = offset_y_range * reso_multi.y
	
	var pos_x = clamp(mouseGlobalPos.x,0,size.x)
	var pos_y = clamp(mouseGlobalPos.y,0,size.y)
	
	position.x = remap(pos_x,0.0,size.x,
	offset_x.x,offset_x.y)
	position.y = remap(pos_y,size.y,0.0,
	offset_y.x,offset_y.y)
