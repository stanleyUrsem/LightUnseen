extends Node2D

@export var scene_name : String
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"
@onready var sceneManager : SceneManager = $"/root/MAIN/SceneManager"


func _ready():
	if(saveManager.loaded_data.has("played_scenes")):
		if(saveManager.loaded_data["played_scenes"].has(scene_name)):
			queue_free()
	sceneManager.OnScenePlayed.connect(check_for_scene)

func check_for_scene(scene: String):
	if(scene_name == scene):
		queue_free()
