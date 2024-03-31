extends "res://Maps/BGMArea.gd"

@export_file() var old_map : String
@export_file() var new_map : String
var mapSwitcher : MapSwitcher

func _ready():
	super()
	mapSwitcher = get_node("/root/MAIN") as MapSwitcher
	mapSwitcher.add_map_data(self,old_map,new_map)
