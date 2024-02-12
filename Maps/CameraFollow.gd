extends Camera2D

class_name CameraFollow

@export var follow_targets : Array[Node2D]
@export var index: int


func _process(delta):
	position = follow_targets[index].position
