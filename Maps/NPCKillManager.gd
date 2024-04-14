extends Node2D

@onready var eventsManager : EventsManager = $"/root/MAIN/EventsManager"
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"

@export var nodes_to_remove : Array[Node2D]
@export var areas_to_enable : Array[Area2D]
@export var bgm_areas : Array[BGMArea]
@export var bgm_out : int


var amount_killed : int
var map_cleared : bool
func _ready():
	eventsManager.OnNpcKilled.connect(npc_killed)
	
	if(saveManager.loaded_data.has("npc_amount_killed")):
		amount_killed = saveManager.loaded_data["npc_amount_killed"]
	if(amount_killed > 0):
		clear_map()


func clear_map():
	if(map_cleared):
		return
	for node in nodes_to_remove:
		if(node != null):
			node.queue_free.call_deferred()
	for area in areas_to_enable:
		area.collision_mask = 16
	for area in bgm_areas:
		area.old_bgm = bgm_out
	map_cleared = true	

func npc_killed(type):
	amount_killed += 1
	saveManager.add_data("npc_amount_killed",amount_killed)
	if(!map_cleared):
		clear_map()
	map_cleared = true
