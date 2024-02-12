extends Area2D

@export var old_height : float
@export var new_height : float


func _ready():
	var fogManager = get_node("/root/MAIN/FogManager")
	fogManager.add_fog_data(self,old_height,new_height)
