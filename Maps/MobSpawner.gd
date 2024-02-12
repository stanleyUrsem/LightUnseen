extends Node2D

@export var mobs : Array[PackedScene]
@export var tileMap :TileMap
@export var layer : int
@export var enable_spawn_mobs : bool
var spawn_dict : Dictionary
var prng : PRNG

func _ready():
	if(!enable_spawn_mobs):
		return
	prng = PRNG.new(333)
	create_spawnpoints()
	spawn_mobs()

func create_spawnpoints():
	var cells = tileMap.get_used_cells(layer)
	
	for cell in cells:
		var tile_data = tileMap.get_cell_tile_data(layer,cell)
		var spawn_mob_type = tile_data.get_custom_data_by_layer_id(1)
		if(spawn_mob_type > 0):
			if(spawn_dict.has(spawn_mob_type)):
				var spawn_points = spawn_dict[spawn_mob_type]
				var pos = tileMap.to_global(tileMap.map_to_local(cell))
				spawn_points.append(pos)
			else:
				var spawn_points : Array[Vector2]
				var pos = tileMap.to_global(tileMap.map_to_local(cell))
				spawn_points.append(pos)
				spawn_dict[spawn_mob_type] = spawn_points
			

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
	var mob = mobs[mob_type].instantiate()
	mob.position = spawn_point
	var ai = mob.get_node("AI")
	ai.mob_type = mob_type
	add_child(mob)

func spawn_mobs():
	var index = 0
	for key in spawn_dict:
		var value = spawn_dict[key]
		for spawn_point in value:
			index+=1
			var mob = mobs[key-1].instantiate()
			mob.name = "%s %d" % [mob.name,index]
			mob.position = spawn_point
			add_child(mob)
			var ai = mob.get_node("AI")
			ai.mob_type = key
			

