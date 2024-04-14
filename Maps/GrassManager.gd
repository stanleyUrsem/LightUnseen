extends TileManager

@export var chance : float
@export var scale_range : Vector2
@export var offset_radius : float
@export var amount : int
@export var safe_loops : int
@export_file() var tile_path : String
var current_index
func _preload_scene():
	tile = load(tile_path)
	#tile = preload("res://Maps/grass2.tscn")
func _create_tiles():
	for i in amount:
		current_index = i
		super()
	
	
func check_other_layers(tilePos,layer)-> bool:
	var datas : Array[int]
	
	for i in tileMap.get_layers_count():
		var data = tileMap.get_cell_tile_data(i,tilePos)
		if(data != null):
			datas.append(i)
#			if(i != layer):
#				print("Found layer: ", i)
	
	return datas.size() > 1 || datas.size() == 0

func _create_tile(tilePos,layer):
	if(check_other_layers(tilePos,layer)):
		return
	var layer_modulate = tileMap.get_layer_modulate(layer)	
	if(current_index == 0):
		super(tilePos,layer)
		created_tile.setup(prng.range_f(-99,99),prng.range_i_mn(4,7))
		var resource_amount = prng.range_i_mn(2,5)
		created_tile.set_meta("resource_amount", resource_amount)
		created_tile.modulate = layer_modulate
		created_tile.OnPickUp.connect(_erase_tile)
		return
		
	if(prng.value() >= (1.0-chance)):
		var offset = prng.random_unit_circle(true) * offset_radius
		var offset_i = Vector2i(int(offset.x),int(offset.y))
		var old_offset = offset
		var loops = 0
		while(check_other_layers(tilePos+offset_i,layer)):
			offset = prng.random_unit_circle(true) * offset_radius
			offset_i = Vector2i(offset)
#			print("offset int: ",offset_i)
			
			if(loops > safe_loops):
				print("UNSAFE")
				break
			loops+=1
		super(tilePos,layer)
#		if(loops > 0):
#			print("\nChanged: ", old_offset,"\nTo: ",offset)
		if(check_other_layers(tilePos+offset_i,layer)):
			print("This should not be called")
		created_tile.setup(prng.range_f(-99,99),prng.range_i_mn(4,7))
		created_tile.global_position += Vector2(offset_i)
		created_tile.scale = Vector2(1.0,1.0) * prng.range_f(scale_range.x,scale_range.y)
		var resource_amount = prng.range_i_mn(2,5)
		created_tile.set_meta("resource_amount", resource_amount)
		created_tile.modulate = layer_modulate
		created_tile.OnPickUp.connect(_erase_tile)
		if(debug):
			print("Creating tile at: %v" % created_tile.global_position)
