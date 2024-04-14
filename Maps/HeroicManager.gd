extends Node2D

@export var normal_scenes : Array[Node2D]
@export var heroic_scenes : Array[Node2D]
@onready var eventsManager : EventsManager = $"/root/MAIN/EventsManager"
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"

var heroic : bool
var fam_killed : bool
func _ready():
	var fam_killed_key  = "family_killed"
	
	if(saveManager.loaded_data.has(fam_killed_key)):
		fam_killed = saveManager.loaded_data[fam_killed_key]
		if(fam_killed):
			clear_heroic_map()
	var key = "carion_skills"
	if(saveManager.loaded_data.has(key)):
		var carion_skills = saveManager.loaded_data[key]
		for skill_name in carion_skills:
			if(skill_name == "Rock Throw"):
				set_heroic()
				break
	
	if(!heroic):
		eventsManager.OnPickUpStone.connect(set_heroic)
	if(!fam_killed):
		eventsManager.OnFamilyKilled.connect(clear_heroic_map)
func set_fam_killed():
	eventsManager.OnFamilyKilled.emit()
func set_heroic():
	if(fam_killed):
		return
	heroic = true
	clear_map()
func clear_heroic_map():
	if(!fam_killed):
		fam_killed = true
		saveManager.add_data("family_killed", true,true)
		
	for scene in heroic_scenes:
		if(scene != null):
			scene.queue_free.call_deferred()
func clear_map():
	for scene in normal_scenes:
		if(scene != null):
			scene.queue_free.call_deferred()
	
