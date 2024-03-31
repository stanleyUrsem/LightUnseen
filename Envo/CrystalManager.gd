extends TileManager

class_name CrystalManager
#@export var tileMap: TileMap
#@export var layer : int
#@export var respawn_curve : Curve
#var tile

func _preload_scene():
	tile = preload("res://Maps/Crystal.tscn")



func _create_tile(tilePos,layer):
	setup_tile(tilePos,layer)
	var spawn_mob_type = tile_data.get_custom_data_by_layer_id(1)
	if(spawn_mob_type > 0):
		return
	create_tile(tilePos,layer)
	var resource_amount = tile_data.get_custom_data_by_layer_id(0)
	
	var collider = created_tile.get_child(1) as CollisionShape2D

	created_tile.set_meta("resource_amount", resource_amount)
	created_tile.OnPickUp.connect(_erase_tile)

