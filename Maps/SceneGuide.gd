extends Line2D
@export var scene_name_enable : String
@export var scene_name_disable : String

func _ready():
	var sceneManager = get_node("/root/MAIN/SceneManager")
	sceneManager.OnScenePlayed.connect(on_scene_played)
	

func on_scene_played(scene : String):
	if(scene_name_enable == scene):
		visible = true
	if(scene_name_disable == scene):
		visible = false
