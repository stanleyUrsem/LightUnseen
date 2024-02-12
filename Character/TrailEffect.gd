extends Line2D
class_name TrailEffect

@export var queue : Array
@export var max_length : int
func update_trail():
	var pos = _get_position()
	queue.push_front(pos)
	
	if(queue.size()> max_length):
		queue.pop_back()
	
	clear_points()
	
	for point in queue:
		add_point(point)




func _get_position() -> Vector2:
	return global_position
