extends Node
class_name Skill

var skillData : SkillData
var eventsManager : EventsManager
var notifier : Notifier
var obtained : bool
var playerTransformer : PlayerTransformer
var skillsManager : SkillsManager
func _setup(p_skillData, p_eventsManager: EventsManager):
	skillData = p_skillData
	eventsManager = p_eventsManager 
	_setup_condition()
	
func _setup_condition():
	pass
	
func _on_obtained():
	obtained = true
	notifier.show_skill_obtained(skillData)
	if(playerTransformer.current_form == skillData.form_type):
		playerTransformer.active_form.get_node("Abilities").add_ability(skillData)
