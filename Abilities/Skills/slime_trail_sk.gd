extends Skill

class_name slime_trail_sk

var transform_skill : Skill

func _setup_vars(p_transform_skill):
	transform_skill = p_transform_skill

func _setup_obtain_event():
	eventsManager.OnSkillObtained.connect(_check_obtained)
func _disable_obtain_event():
	eventsManager.OnSkillObtained.disconnect(_check_obtained)
	
func _check_obtained(skill : SkillData):
	if(obtained):
		return
	if(skill.displayName == transform_skill.display_name):
		eventsManager.OnSkillObtained.disconnect(_check_obtained)
		_on_obtained()


