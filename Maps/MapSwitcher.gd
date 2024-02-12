extends Node
#@export var player : CharacterBody2D
@export var camera : Camera2D
@export var switch_speed : float
@export var maps : Array[String]
@export var active_map : String
var current_created_maps : Dictionary
var switch_tween : Tween
var loaded_maps : Dictionary
var is_switching : bool
var current_area
#Zoom in
#Stop input
#Move automatic from cave exit
#to other 
#Zoom out
#func _ready():
	#for map in maps:
		#var loaded_map = load(map)
		#print("loading.. : ", map.trim_suffix())
		#loaded_maps[map.get_name(map.get_name_count()-1)] = loaded_map

func _ready():
	is_switching = false
	#playerTransformer.on_form_changed.connect(_set_player_follow)
	var loaded_map = load(active_map)
	loaded_maps[active_map] = loaded_map
	var created_map = loaded_map.instantiate()
	add_child(created_map)
	#move_player(created_map.base_spawn_point)
	load_other_maps(created_map)
	load_maps(created_map)
	connect_areas(created_map)

func connect_areas(map_data :MapData):
	for area in map_data.area_doors:
		var area_string = area.get_meta("connected_area")
		if(area_string.is_empty() || area_string == null):
			continue
		var other_area = get_node(NodePath(area_string))
		#print(area_string)
		#print(NodePath(area_string))
		#print(other_area)
		area.body_exited.connect(func(body):
			if(area == current_area):
				return
			current_area = other_area
			switch_map(other_area.position,map_data))

func load_other_maps(map_data:MapData):
	for map in map_data.other_maps:
		if(!loaded_maps.has(map)):
			var loaded_map = load(map)
			loaded_maps[map] = loaded_map
#Need data:
#Camera
#Player
#PlayerMovement
func switch_map(pos, map_data):
	if(is_switching):
		return
	#player.stopMovement = true
	is_switching = true
	if(switch_tween != null && switch_tween.is_running()):
		switch_tween.kill()
	
	switch_tween = get_tree().create_tween()
	#var dist = player.position.distance_to(pos)
	#switch_tween.tween_method(move_player,player.position,pos,switch_speed)
	switch_tween.tween_callback(func(): 
		load_other_maps(map_data)
		load_maps(map_data)
		#player.stopMovement = false
		#is_switching = false
		)



func load_maps(map_data):
	
	#for map in current_created_maps:
		#if(!map_data.other_maps.has(map)):
			#map.queue_free()
			#current_created_maps.erase()
	var to_erase : Array
	for key in current_created_maps:
		var value = current_created_maps[key]
		if(!map_data.other_maps.has(key)):
			value.queue_free()
			to_erase.append(key)
	
	for key in to_erase:
		current_created_maps.erase(key)
	
	for map in map_data.other_maps:
		if(!current_created_maps.has(map)):
			var created_map = loaded_maps[map].instantiate()
			add_child(created_map)
			current_created_maps[map] = created_map
			connect_areas(created_map)
	
	
