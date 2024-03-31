extends Skill

class_name carion_transform_sk


var other_skill : Skill

func _setup_vars(p_other_skill):
	other_skill = p_other_skill

func _setup_obtain_event():
	eventsManager.OnSkillObtained.connect(_check_obtained)
func _disable_obtain_event():
	eventsManager.OnSkillObtained.disconnect(_check_obtained)
func _check_obtained(skill:SkillData):
	if(obtained):
		return
	
	if(skill.displayName == other_skill.display_name):
		_on_obtained()
		eventsManager.OnSkillObtained.disconnect(_check_obtained)


