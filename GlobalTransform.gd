extends Node2D

@export var mats : Array[Material]
@export var trans : Transform2D
#func _ready():
	
#	for i in mats.size():
#		mats[i].set_shader_parameter("global_transform",get_global_transform())

func _process(delta):
	trans = get_viewport_transform()
	for i in mats.size():
		mats[i].set_shader_parameter("global_transform",trans)
