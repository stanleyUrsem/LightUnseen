extends Skill

class_name roll_sk

var hit_times : int
var current_hit_times : int

func _setup_vars(p_hit_times):
	hit_times = p_hit_times
	
func _setup_obtain_event():
	eventsManager.OnHitBy.connect(_check_obtained)
func _disable_obtain_event():
	eventsManager.OnHitBy.disconnect(_check_obtained)
	
func _check_obtained(type, damage):
	if(obtained):
		return
	current_hit_times += 1
	if(hit_times >= current_hit_times):
		_on_obtained()
		eventsManager.OnSkillObtained.disconnect(_check_obtained)
			


