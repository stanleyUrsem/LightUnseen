extends Skill

class_name boulder_throw_sk


var other_skill : Skill

func _setup_vars(p_other_skill):
	other_skill = p_other_skill

func _setup_obtain_event():
	eventsManager.OnSkillUsed.connect(_check_obtained)
func _disable_obtain_event():
	eventsManager.OnSkillUsed.disconnect(_check_obtained)
func _check_obtained(skill:SkillData):
	if(obtained):
		return
	if(skill.displayName == other_skill.display_name):
		_on_obtained()
		eventsManager.OnSkillUsed.disconnect(_check_obtained)


