extends Node2D

class_name NPCSpawner

@export var npcs : Array[PackedScene]
@export var npc_spawn_points : Array[Marker2D]

var created_npcs : Array[Node2D]

func _ready():
	
	for i in get_child_count():
		var child = get_child(i)
		npc_spawn_points.append(child)
	
	for npc in npcs:
		for point in npc_spawn_points:
			var created_npc =  npc.instantiate()
			add_child(created_npc)
			created_npcs.append(created_npc)
			created_npc.global_position = point.global_position

func clean_up():
	for npc in created_npcs:
		var ai = npc.get_node("AI") as AI
		ai.ai_enabled = false
		ai.currentState = null
	
