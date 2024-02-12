extends TileMap


func remove_tile(data: TileData,res,respawn_duration, on_erased):
	var respawn_tween = get_tree().create_tween() as Tween
	respawn_tween.tween_method(func(x):
		var clr = Color(1,1,1,x)
		data.modulate = clr
		,1.0,0.0,0.5)
	respawn_tween.tween_callback(func():
		data.set_custom_data_by_layer_id(0,0)
		on_erased.call()
		)
	respawn_tween.tween_method(func(x):
		var clr = Color(1,1,1,x)
		data.modulate = clr
		,0.0,1.0,respawn_duration)
	respawn_tween.tween_callback(func():
		data.set_custom_data_by_layer_id(0,res)
		)
#	respawn_tween.tween_interval(0.5)
#	respawn_tween.tween_callback(func():
#		erase_cell(layer,coords)
#		on_erased.call())
#	respawn_tween.tween_interval(respawn_duration)
#	respawn_tween.tween_callback(func():
#		print("Setting cell")
#		set_cell(layer,coords,
#		get_cell_source_id(layer,coords),
#		get_cell_atlas_coords(layer,coords))
#		force_update(layer)
#		)
		
#func fade_out_tile(x):
	
