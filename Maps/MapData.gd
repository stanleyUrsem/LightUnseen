extends Node

class_name MapData

@export var other_maps : Array[String]
@export var base_spawn_point : Vector2
@export var area_doors : Array[Area2D]
@export var tileMap : TileMap
@export var mob_layer : int
@export var mob_type_chance: Array[Vector2i]
@export var mob_spawn_rate : float

@export var tileManagers : Array[TileManager]
@export var npcManagers : Array[NPCSpawner]
var npcs_created : bool

func clean_up_map():
	for npcManager in npcManagers:
		npcManager.clean_up()
	for tileManager in tileManagers:
		tileManager.clean_up()
	#queue_free()
func create_npcs():
	for npcManager in npcManagers:
		npcManager.create_npcs()
	npcs_created = true
func recreate_map():
	for npcManager in npcManagers:
		npcManager.reset_npcs()
	for tileManager in tileManagers:
		tileManager.cleaning_up = false
