extends Node2D

class_name TileManager
@export var tileMap: TileMap
@export var layer : int
@export var respawn_curve : Curve
@export var erase : bool

var tile
var pos
var coords
var tile_data
var created_tile
var created_sprite
func _preload_scene():
	tile = preload("res://Maps/Crystal.tscn")

func _ready():
	_preload_scene()
	
	_create_tiles()	

func _create_tiles():
	var cells = tileMap.get_used_cells(layer)
		
	for i in cells.size():
		_create_tile(cells[i],layer)
		
func setup_tile(tilePos,layer):
	pos = tileMap.to_global(tileMap.map_to_local(tilePos))
	coords = tileMap.get_cell_atlas_coords(layer,tilePos)
	tile_data = tileMap.get_cell_tile_data(layer,tilePos)
	
func create_tile(tilePos,layer):
	created_tile = tile.instantiate()
	created_sprite = created_tile.get_node("TileSprite") as Sprite2D
	add_child.call_deferred(created_tile)
	created_tile.position = pos 
	if(erase):
		created_sprite.frame_coords = coords
		tileMap.erase_cell(layer,tilePos)

func _create_tile(tilePos,layer):
	setup_tile(tilePos,layer)
	create_tile(tilePos,layer)
	


func _erase_tile(tile,on_erased, duration):
	pass

