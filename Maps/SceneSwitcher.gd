extends Node2D

class_name SceneSwitcher

@export var scene : PackedScene
@export var protected_nodes : Array[Node]
var switching_scene : bool
var wait_tween
func _ready():
	switching_scene = false

func switch_scene():
	if(switching_scene):
		return
	switching_scene = true
	
	if(wait_tween != null):
		wait_tween.kill()
	wait_tween = get_tree().create_tween()
	wait_tween.tween_interval(0.5)
	wait_tween.tween_callback(switch_no_wait)	

func switch_no_wait():
	var new_scene = scene.instantiate() 
	for node in protected_nodes:
		node.reparent(new_scene)
	get_tree().root.add_child(new_scene)
	var scene_switcher = new_scene.get_node_or_null("SceneSwitcher")
	if(scene_switcher):
		for node in protected_nodes:
			scene_switcher.protected_nodes.append(node)
	erase_old_scene()
	#return new_scene
func erase_old_scene():
	switching_scene = false
	get_parent().queue_free()
	
