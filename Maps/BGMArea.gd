extends Area2D

@export var old_bgm : int
@export var new_bgm : int


func _ready():
	var bgmManager = get_node("/root/MAIN/BGMManager")
	bgmManager.add_bgm_data(self,old_bgm,new_bgm)
