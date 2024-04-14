extends Node
class_name Skill

var skillData : SkillData
var eventsManager : EventsManager
var obtained : bool
var playerTransformer : PlayerTransformer
var skillsManager : SkillsManager
var saveManager : SaveManager
var display_name : String :
	get:
		return skillData.displayName

signal OnObtain(skill)	
func load_vars(loaded_data):
	pass
func save_vars():
	pass
func _setup(p_skillData, p_eventsManager: EventsManager,p_skillsManager,p_saveManager):
	skillData = p_skillData
	eventsManager = p_eventsManager
	skillsManager = p_skillsManager
	saveManager = p_saveManager
	obtained = false
	_setup_obtain_event()
func _setup_obtain_event():
	pass
func _disable_obtain_event():
	pass
func _on_obtained():
	obtained = true
	OnObtain.emit(self)


