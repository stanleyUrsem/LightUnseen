extends Node
class_name Skill

var skillData : SkillData
var eventsManager : EventsManager
var obtained : bool
var playerTransformer : PlayerTransformer
var skillsManager : SkillsManager

var display_name : String :
	get:
		return skillData.displayName

signal OnObtain(skill)	

func _setup(p_skillData, p_eventsManager: EventsManager,p_skillsManager):
	skillData = p_skillData
	eventsManager = p_eventsManager
	skillsManager = p_skillsManager
	obtained = false
	_setup_obtain_event()
func _setup_obtain_event():
	pass
func _disable_obtain_event():
	pass
func _on_obtained():
	obtained = true
	OnObtain.emit(self)


