extends Node2D

class_name MobSpawner

@export var mobs : Array[PackedScene]
@export var ignore_mob_spawns : Array[int]
#@export var tileMap :TileMap
#@export var layer : int
@export var enable_spawn_mobs : bool
@export var wall_cast : ShapeCast2D
@export var spawn_cooldown : float
@export var max_spawns : int
@export var max_loops : int
var spawn_dict : Dictionary
var prng : PRNG
var cameraFollow : CameraFollow
var active_map : MapData
var spawned_mobs : Array
var other_spawned_mobs : Array
var spawn_points : Array[Vector2]
var current_cooldown : float
var created : int
var spawn_rate
var max_active_mobs : int
func _ready():
	if(!enable_spawn_mobs):
		return
	#cameraFollow = get_node("/root/MAIN/Camera2D")
	prng = PRNG.new(333)
	#create_spawnpoints()
	#spawn_mobs()
	
#Put this in a area trigger
#if things are lagging
func clear_mobs():
	active_map = null
	for mob in spawned_mobs:
		if(mob != null):
			mob.queue_free()
	for mob in other_spawned_mobs:
		if(mob != null):
			mob.queue_free()
	other_spawned_mobs.clear()	
	spawned_mobs.clear()
	
#func create_spawnpoints(tileMap,layer):
	#spawn_dict.clear()
	#var cells = tileMap.get_used_cells(layer)
	#active_tileMap = tileMap
	#for cell in cells:
		#var tile_data = tileMap.get_cell_tile_data(layer,cell)
		#var spawn_mob_type = tile_data.get_custom_data_by_layer_id(1)
		#if(spawn_mob_type > 0):
			#if(spawn_dict.has(spawn_mob_type)):
				#var spawn_points = spawn_dict[spawn_mob_type]
				#var pos = tileMap.to_global(tileMap.map_to_local(cell))
				#spawn_points.append(pos)
			#else:
				#var spawn_points : Array[Vector2]
				#var pos = tileMap.to_global(tileMap.map_to_local(cell))
				#spawn_points.append(pos)
				#spawn_dict[spawn_mob_type] = spawn_points
			

func respawn_timer(mob_type):
	var respawn_tween = get_tree().create_tween() as Tween
	respawn_tween.tween_interval(5.0)
	respawn_tween.tween_callback(func(): 
		var amount = prng.range_i_mn(0,3)
		for i in amount:
			respawn_mob(mob_type)
		)

func respawn_mob(mob_type):
	var value = spawn_dict[mob_type]
	var spawn_point = prng.random_element(value)
	var mob = mobs[mob_type-1].instantiate()
	mob.position = spawn_point
	var ai = mob.get_node("AI")
	ai.mob_type = mob_type
	ai.mob_spawner = self
	
	add_child(mob)
	return ai

func _physics_process(delta):
	if(!enable_spawn_mobs):
		return
	if(active_map == null):
		return
	current_cooldown -= delta
	
	if(current_cooldown <= 0):
		
		current_cooldown = max(spawn_cooldown / spawn_rate,15.0)
		var spawn_amount = prng.range_i_mn(1,3)
		for i in range(spawn_amount):
			spawn_mobs(active_map)

func set_active_map(mapData):
	created = 0
	active_map = mapData
	spawn_rate = mapData.mob_spawn_rate
	max_active_mobs = round(max_spawns * (1.0 + (spawn_rate/10.0)))
	current_cooldown = 0
func spawn_mobs(mapData : MapData):
	if(mapData.mob_spawn_rate <= 0):
		return
	
	if(spawned_mobs.size() >= max_active_mobs):
		return
	
	var tileMap = mapData.tileMap
	var layer = mapData.mob_layer
	var mobs_type_chance = mapData.mob_type_chance
	var spawn_rate = mapData.mob_spawn_rate
	var pos = tileMap.get_child( prng.range_i_mn(0,tileMap.get_child_count()-1)).global_position
	#while(created < amount):
	var weighted_types : Array[WeightedTuple] = []
	for type_chance in mobs_type_chance:
		weighted_types.append(WeightedTuple.new(type_chance.y,type_chance.x))
	var mob_type = prng.weighted_range(weighted_types)
	var mob = mobs[mob_type].instantiate()
	
	#var current_loops = 0
	#while(wall_cast.is_colliding() && current_loops < max_loops):
		#if(current_loops > max_loops-2):
			#print("WAHTS HAPPENINE")
		#current_loops += 1
		#var cell = prng.random_element(tileMap.get_used_cells(layer))
		#pos = tileMap.to_global(tileMap.map_to_local(cell))
		##HelperFunctions.cell_to_global(tileMap,cell,mob)
		#wall_cast.global_position = mob.global_position
		
	
	mob.name = "%s %d" % [mob.name,created]
	mob.global_position = pos
	print("%s Spawned at: %v" % [mob.name,mob.global_position])
	mob.rotation_degrees *= -1.0
	#tileMap.add_sibling(mob)
	add_child.call_deferred(mob)
	var ai = mob.get_node("AI")
	ai.mob_type = mob_type
	ai.mob_spawner = self
	spawned_mobs.append(mob)
	created += 1
		
		
		
#
#func spawn_mobs():
	#var index = 0
	#for key in spawn_dict:
		#if(ignore_mob_spawns.has(key)):
			#continue
		#var value = spawn_dict[key]
		#for spawn_point in value:
			#index+=1
			#var mob = mobs[key-1].instantiate()
			#mob.name = "%s %d" % [mob.name,index]
			#mob.position = spawn_point
			#print("%s Spawned at: %v" % [mob.name,spawn_point])
			#active_tileMap.add_sibling(mob)
			##cameraFollow.follow_targets.append(mob)
			#var ai = mob.get_node("AI")
			#ai.mob_type = key
			#ai.mob_spawner = self
			#spawned_mobs.append(mob)
			#

