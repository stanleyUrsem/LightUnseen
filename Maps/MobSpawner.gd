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
var spawn_points : Array[Vector2]
var current_cooldown : float
var created : int
var spawn_rate
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
		mob.queue_free()
		
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
		
		current_cooldown = spawn_cooldown / spawn_rate
		var spawn_amount = round(pow(spawn_rate,2.0))
		print("Spawning: ", spawn_amount)
		for i in range(spawn_amount):
			spawn_mobs(active_map)

func set_active_map(mapData):
	created = 0
	active_map = mapData
	spawn_rate = mapData.mob_spawn_rate
	
func spawn_mobs(mapData : MapData):
	if(mapData.mob_spawn_rate <= 0):
		return
	
	if(round(max_spawns * spawn_rate) > spawned_mobs.size()):
		return
	
	var tileMap = mapData.tileMap
	var layer = mapData.mob_layer
	var mobs_type_chance = mapData.mob_type_chance
	var spawn_rate = mapData.mob_spawn_rate
	var pos = Vector2.ZERO
	#while(created < amount):
	#var current_loops = 0
	#while(wall_cast.is_colliding() && current_loops < max_loops):
		#if(current_loops > max_loops-2):
			#print("WAHTS HAPPENINE")
		#current_loops += 1
	var cell = prng.random_element(tileMap.get_used_cells(layer))
	pos = tileMap.to_global(tileMap.map_to_local(cell))
	wall_cast.global_position = pos
		
	var weighted_types : Array[WeightedTuple] = []
	for type_chance in mobs_type_chance:
		weighted_types.append(WeightedTuple.new(type_chance.y,type_chance.x))
	var mob_type = prng.weighted_range(weighted_types)
	
	var mob = mobs[mob_type].instantiate()
	mob.name = "%s %d" % [mob.name,created]
	mob.position = pos
	print("%s Spawned at: %v" % [mob.name,pos])
	tileMap.add_sibling(mob)
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

