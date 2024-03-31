extends Skill

class_name pierce_sk


var other_skill : Skill
var amount : int
var current_amount

func _setup_vars(p_other_skill,p_amount):
	current_amount = 0
	other_skill = p_other_skill
	amount = p_amount

func _setup_obtain_event():
	eventsManager.OnSkillUsed.connect(_check_obtained)
func _disable_obtain_event():
	eventsManager.OnSkillUsed.disconnect(_check_obtained)
	
func _check_obtained(skill:SkillData):
	if(obtained):
		return
	
	if(skill.displayName == other_skill.display_name ):
		current_amount += 1
		if(current_amount >= amount):
			_on_obtained()
			eventsManager.OnSkillUsed.disconnect(_check_obtained)
			


