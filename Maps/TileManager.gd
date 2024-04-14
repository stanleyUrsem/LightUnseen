extends Node2D

class_name TileManager
@export var tileMap: TileMap
@export var layer : int
@export var respawn_curve : Curve
@export var erase : bool
@export var debug : bool
var prng
var tile
var pos
var coords
var tile_data
var created_tile
var created_sprite
var created_tweens : Array[Tween]
var cleaning_up : bool
func _preload_scene():
	tile = preload("res://Maps/Crystal.tscn")

func _ready():
	prng = PRNG.new(RandomNumberGenerator.new().randi_range(-999,999))
	cleaning_up = false
	print("Creating tiles: ", name)
	_preload_scene()
	_create_tiles()	

func _create_tiles():
	cleaning_up = false
	var cells = tileMap.get_used_cells(layer)
		
	for i in cells.size():
		_create_tile(cells[i],layer)
		
func setup_tile(tilePos,layer):
	pos = tileMap.to_global(tileMap.map_to_local(tilePos)) - tileMap.global_position
	coords = tileMap.get_cell_atlas_coords(layer,tilePos)
	tile_data = tileMap.get_cell_tile_data(layer,tilePos)
	
func create_tile(tilePos,layer):
	created_tile = tile.instantiate()
	if(created_tile is Interactable):
		created_tile.setup_vars(prng)
	else:
		print("Created tile is not interactable: ", created_tile.name)
	created_sprite = created_tile.get_node("TileSprite") as Sprite2D

	add_child.call_deferred(created_tile)
	created_tile.global_position = pos 
	if(erase):
		created_sprite.frame_coords = coords
		tileMap.erase_cell(layer,tilePos)

func _create_tile(tilePos,layer):
	setup_tile(tilePos,layer)
	create_tile(tilePos,layer)
	
func clean_up():
	cleaning_up = true
	for tween in created_tweens:
		tween.kill()

func _erase_tile(tile,on_erased, duration):
	if(cleaning_up):
		return
	#var tile = collider.get_parent()
	var sprite = tile.get_child(0) as Sprite2D
	var collider = tile.get_child(1) as CollisionShape2D
	var respawn_tween = get_tree().create_tween() as Tween
	created_tweens.append(respawn_tween)
	#print("Erasing tile with duration: ", tile.name ,"\t", duration )
	collider.disabled = true
	
	respawn_tween.tween_method(func(x):
		var clr = Color(1,1,1,x)
		if(sprite == null):
			respawn_tween.kill()
			return
		if(cleaning_up):
			return
		sprite.modulate = clr
		,1.0,0.0,0.5)
	respawn_tween.tween_callback(func():
		if(cleaning_up):
			return
		on_erased.call()
		)
	respawn_tween.tween_method(func(x):
		var value = respawn_curve.sample(x)
		var clr = Color(1,1,1,value)
		if(sprite == null):
			respawn_tween.kill()
			return
		if(cleaning_up):
			return
		sprite.modulate = clr
		,0.0,1.0,duration)
	respawn_tween.tween_callback(func():
		#print("collider enabled", tile.name)
		if(cleaning_up):
			return
		if(collider != null):
			collider.disabled = false
			cleaning_up = false
			created_tweens.erase(respawn_tween)
		)

