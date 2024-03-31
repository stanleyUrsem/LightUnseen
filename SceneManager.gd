extends Node2D

class_name SceneManager

@export var scenes : Array[String]
@export var mapSwitcher : MapSwitcher
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"
var played_scenes : Array[String]
var current_scene : CutsceneDirector

func _ready():
	mapSwitcher.OnMapLoaded.connect(setup)

func setup():
	for scene in saveManager.loaded_data["played_scenes"]:
		if(!played_scenes.has(scene)):
			played_scenes.append(scene)
	
func add_played_scene(scene : String):
	if(played_scenes.has(scene)):
		return
	played_scenes.append(scene)
	saveManager.add_data("played_scenes",played_scenes)
func get_scene_index(scene : String):
	return int(scene.split("_")[1])
func scene_available(scene:String):
	var index = get_scene_index(scene)
	var scenes_completed =  1
	while(index > 0):
		index -= 1 
		for i in played_scenes.size():
			var scene_index = get_scene_index(played_scenes[i])
			if(index == scene_index):
				scenes_completed += 1
	
	return scenes_completed == get_scene_index(scene)
		
func already_played_scene(scene:String):
	return played_scenes.has(scene)
func new_scene(scene : CutsceneDirector):
	if(already_played_scene(scene.name)):
		scene.get_parent().queue_free()
		current_scene = null
		return
	if(!scene_available(scene.name) || current_scene == scene):
		return
	if(current_scene != null):
		current_scene.get_parent().queue_free()
	scene.get_parent().visible = true
	current_scene = scene
	scene.transition()
	
