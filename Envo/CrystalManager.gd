extends TileManager

class_name CrystalManager
#@export var tileMap: TileMap
#@export var layer : int
#@export var respawn_curve : Curve
#var tile

func _preload_scene():
	tile = preload("res://Maps/Crystal.tscn")

func _ready():
	_preload_scene()
	var cells = tileMap.get_used_cells(layer)
	print("setup crystals")
	
	for i in cells.size():
		_create_tile(cells[i],layer)

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

func _erase_tile(tile,on_erased, duration):
	#var tile = collider.get_parent()
	var sprite = tile.get_child(0) as Sprite2D
	var collider = tile.get_child(1) as CollisionShape2D
	var respawn_tween = get_tree().create_tween() as Tween
	print("Erasing tile with duration: ", tile.name ,"\t", duration )
	collider.disabled = true
	
	respawn_tween.tween_method(func(x):
		var clr = Color(1,1,1,x)
		sprite.modulate = clr
		,1.0,0.0,0.5)
	respawn_tween.tween_callback(func():
		on_erased.call()
		)
	respawn_tween.tween_method(func(x):
		var value = respawn_curve.sample(x)
		var clr = Color(1,1,1,value)
		sprite.modulate = clr
		,0.0,1.0,duration)
	respawn_tween.tween_callback(func():
		print("collider enabled", tile.name)
		collider.disabled = false
		)

