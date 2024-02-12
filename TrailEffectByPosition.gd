extends TrailEffect

@export var offset : Vector2
@export var node : Node2D
func _get_position()-> Vector2:
	#return get_global_mouse_position() - get_parent().position
	return node.position + offset
