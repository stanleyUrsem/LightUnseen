extends Area2D

@export var old_height : float
@export var new_height : float

var fogManager
func _ready():
	fogManager = get_node("/root/MAIN/FogManager")
	fogManager.add_fog_data(self,old_height,new_height)


func apply_fog(use_new:bool):
	fogManager.currentHeight = old_height 
	fogManager.new_height = new_height
	fogManager.set_fog_manually(1.0 if use_new else 0.0)
