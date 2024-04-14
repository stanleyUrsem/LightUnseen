extends Node2D

class_name NPCSpawner

@export var npcs : Array[PackedScene]
@export var npc_spawn_points : Array[Marker2D]
var created_npcs : Array[Node2D]

func _ready():
	for i in get_child_count():
		var child = get_child(i)
		npc_spawn_points.append(child)
	#create_npcs()
func reset_npcs():
	for i in created_npcs.size():
		var npc = created_npcs[i]
		var point = npc_spawn_points[i]
		if(npc == null):
			continue
		npc.global_position = point.global_position
		var ai = npc.get_node("AI") as AI
		ai.ai_enabled = true
		ai.reset_ai()
func create_npcs():
	for npc in npcs:
		for point in npc_spawn_points:
			var created_npc =  npc.instantiate()
			var main = get_tree().root.get_child(0)
			main.add_child.call_deferred(created_npc)
			created_npcs.append(created_npc)
			created_npc.global_position = point.global_position
	for npc in created_npcs:
		if(npc == null):
			continue
		npc.reparent.call_deferred(self)
func clean_up():
	print("cleaning up npcs")
	for npc in created_npcs:
		if(npc == null):
			continue
		var ai = npc.get_node("AI") as AI
		ai.ai_enabled = false
		ai.currentState = null
	
