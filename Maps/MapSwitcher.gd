extends Node

class_name MapSwitcher

#@export var player : CharacterBody2D
@export var camera : Camera2D
@export var switch_speed : float
@export var maps : Array[String]
@export_file() var start_map : String
var current_created_maps : Dictionary
var switch_tween : Tween
var loaded_maps : Dictionary
var is_switching : bool
var current_area
var saved_position : Vector2
var entry_position : Vector2
var exit_position : Vector2
var body_position : Vector2
var new_BGM : int
var change_map : bool
var exit_body
var max_distance : float
var current_distance : float
var useY: bool
var old_map
var new_map
var current_map
var saveManager
@export var alpha : float
@export var alphaX : float
@export var alphaY : float
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

##DEATH CAUSES LAG :(
signal OnMapLoaded
func reset_to_central():
	if(current_created_maps.has(start_map)):
		#Already exists so no need to recreate it
		var map_data = current_created_maps[start_map]
		switch_map(map_data)
		return
	else:
		var central = loaded_maps[start_map].instantiate()
		add_child(central)
		switch_map(central)
		

func _ready():
	is_switching = false
	#playerTransformer.on_form_changed.connect(_set_player_follow)
	var loaded_map = load(start_map)
	loaded_maps[start_map] = loaded_map
	var created_map = loaded_map.instantiate()
	current_created_maps[start_map] = created_map
	add_child(created_map)
	#move_player(created_map.base_spawn_point)
	current_map = created_map
	load_other_maps(created_map)
	load_maps(created_map)
	if(!created_map.npcs_created):
		created_map.create_npcs()
	#connect_areas(created_map)
	OnMapLoaded.emit()
	var scene_1 = get_node("/root/MAIN/Central/Scene_1/Scene_1")
	scene_1.play_scene()
	saveManager = get_node("/root/MAIN/SaveManager")
	saveManager.auto_save = true


func connect_areas(map_data :MapData):
	for area in map_data.area_doors:
		var area_string = area.get_meta("connected_area")
		if(area_string.is_empty() || area_string == null):
			continue
		var other_area = get_node_or_null(NodePath(area_string))
		#print(area_string)
		#print(NodePath(area_string))
		#print(other_area)
		if(other_area == null):
			return
		area.body_exited.connect(func(body):
			if(area == current_area):
				return
			current_area = other_area
			switch_map(map_data))

func load_other_maps(map_data:MapData):
	for map in map_data.other_maps:
		if(!loaded_maps.has(map)):
			var loaded_map = load(map)
			loaded_maps[map] = loaded_map
#Need data:
#Camera
#Player
#PlayerMovement
func switch_map(map_data):
	if(is_switching):
		return
	#player.stopMovement = true
	is_switching = true
	if(map_data != current_map):
		load_other_maps(map_data)
		load_maps(map_data)
	current_map = map_data
	switching_done.call_deferred()
	#if(switch_tween != null && switch_tween.is_running()):
		#switch_tween.kill()
	
	#switch_tween = get_tree().create_tween()
	##var dist = player.position.distance_to(pos)
	##switch_tween.tween_method(move_player,player.position,pos,switch_speed)
	#switch_tween.tween_callback(func(): 
		#is_switching = false
		#)
		#load_other_maps(map_data)
		#load_maps(map_data)
		##player.stopMovement = false

func switching_done():
	is_switching = false

func load_maps(map_data):
	if(map_data != current_created_maps[start_map]):
		if(!map_data.npcs_created):
			map_data.create_npcs()
		map_data.recreate_map()
	#map_data.visible = true
	#for map in current_created_maps:
		#if(!map_data.other_maps.has(map)):
			#map.queue_free()
			#current_created_maps.erase()
	var to_erase : Array
	for key in current_created_maps:
		var value = current_created_maps[key]
		if(value == map_data || key == start_map ):
			continue
		if(!map_data.other_maps.has(key)):
			print("Erasing map: %s" % value)
			value.clean_up_map()
			if(value.get_parent() == self):
				remove_child.call_deferred(value)
			#value.visible = false
			#to_erase.append(key)
	#
	#for key in to_erase:
		#current_created_maps.erase(key)
	
	for map in map_data.other_maps:
		if(!current_created_maps.has(map)):
			print("Creating map: %s" % map)
			var created_map = loaded_maps[map].instantiate()
			add_child.call_deferred(created_map)
			current_created_maps[map] = created_map
		else:
			var current_map = current_created_maps[map]
			if(current_map.get_parent() != self):
				add_child.call_deferred(current_map)
			#current_created_maps[map].visible = true
			#map.recreate_map()
			#connect_areas(created_map)
	
	
func add_map_data(area,old,new):
	area.body_entered.connect(save_position_on_enter.bind(old,new,
	area.get_node("Col")))
	area.body_exited.connect(start_elevation_change_on_exit)
func in_between(a,b, dist):
	return a <= b + dist && a >= b - dist

func save_position_on_enter(body, p_old_map,p_new_map,col_node):
	print("Entering ","Body:",body.name)
	
	var area = col_node.get_parent()
	exit_position = area.global_position
	entry_position = area.get_child(1).global_position
	
	useY = abs(exit_position.y - entry_position.y) > 1.0
	if(!current_created_maps.has(p_old_map)):
		print("Old map not created!\n%s" % p_old_map)
		return
	if(!current_created_maps.has(p_new_map)):
		print("New map not created!\n" % p_new_map)
		return
	old_map = current_created_maps[p_old_map]
	new_map = current_created_maps[p_new_map]
	exit_body = body
	#current_BGM = old_BGM
	#new_BGM = p_new_BGM
		#
	#var old_pos = bgm_in.get_playback_position()
	#var in_old_pos = 0.0
	#if(bgm_out.playing):
		#in_old_pos = bgm_out.get_playback_position()
	#if(bgm_in.stream != bgms[new_BGM]):
		#bgm_in.stream = bgms[new_BGM]
		#bgm_in.play(in_old_pos)
	#if(bgm_out.stream != bgms[current_BGM]):
		#bgm_out.stream = bgms[current_BGM]
		#bgm_out.play(old_pos)
	change_map = true
	

func start_elevation_change_on_exit(body):
	if(alpha >= 1.0):
		switch_map(new_map)
	if(1.0 - alpha >= 1.0):
		switch_map(old_map)	
	print("Map change done\nAlpha: %d" % alpha)
	change_map = false
	return


func _process(delta):
	if(!change_map || exit_body == null):
		return
	
	body_position = exit_body.global_position 
	current_distance = (body_position.y -  (entry_position).y)

	alphaY = remap(body_position.y,exit_position.y,entry_position.y,0.0,1.0)
	alphaX = remap(body_position.x,exit_position.x,entry_position.x,0.0,1.0)
	alpha = alphaY if useY else alphaX
	alpha = clamp(alpha,0.0,1.0)
	

	
	
