extends Node2D
@export_range(0,360) var angle : float
@export var radius : int
@export var other_node : Node2D
@export var circle_node : Node2D
func _physics_process(delta):
	circle_node.global_position = get_angle_position(other_node.global_position,angle * delta)

func get_angle_position(point,angle_offset):
	#define a radius
	#get current position
	var pos = circle_node.global_position
	#get point position
	#normalize the direction between
	#var dir = (pos - point).normalized()
	#get the current angle of current position relative to point
	var current_angle = HelperFunctions.get_angle(pos,point) + angle_offset
	#add or subtract from the angle to go to next position
	return point + HelperFunctions.get_point_from_angle(current_angle,radius)
