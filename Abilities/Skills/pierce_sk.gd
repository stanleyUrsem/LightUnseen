extends Skill

class_name pierce_sk


var other_skill : Skill
var amount : int
var current_amount

func _setup_vars(p_other_skill,p_amount):
	current_amount = 0
	other_skill = p_other_skill
	amount = p_amount
func load_vars(loaded_data):
	var key = "pierce_slam_amount_used"
	if(!loaded_data.has(key)):
		return
	current_amount = loaded_data[key]
	if(current_amount >= amount):
		_on_obtained()
		_disable_obtain_event()
		
func _setup_obtain_event():
	eventsManager.OnSkillUsed.connect(_check_obtained)
func _disable_obtain_event():
	eventsManager.OnSkillUsed.disconnect(_check_obtained)
func save_vars():
	saveManager.add_data("pierce_slam_amount_used",current_amount)		
func _check_obtained(skill:SkillData):
	if(obtained):
		return
	
	if(skill.displayName == other_skill.display_name ):
		current_amount += 1.0
		save_vars()
		eventsManager.OnSkillProgress.emit(self,float(current_amount)/float(amount))
		if(current_amount >= amount):
			_on_obtained()
			eventsManager.OnSkillUsed.disconnect(_check_obtained)
			


