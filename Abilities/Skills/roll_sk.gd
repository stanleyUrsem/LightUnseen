extends Skill

class_name roll_sk

var hit_times : int
var current_hit_times : int

func _setup_vars(p_hit_times):
	current_hit_times = 0
	hit_times = p_hit_times
func load_vars(loaded_data):
	var key = "roll_hit_times"
	if(!loaded_data.has(key)):
		return
	current_hit_times = loaded_data[key]
	if(current_hit_times >= hit_times):
		_on_obtained()
		_disable_obtain_event()
func _setup_obtain_event():
	eventsManager.OnHitBy.connect(_check_obtained)
func _disable_obtain_event():
	eventsManager.OnHitBy.disconnect(_check_obtained)
func save_vars():
	saveManager.add_data("roll_hit_times",current_hit_times)	
func _check_obtained(type, damage):
	if(obtained):
		return
	current_hit_times += 1.0
	save_vars()
	var alpha = current_hit_times / float(hit_times)
	eventsManager.OnSkillProgress.emit(self,alpha)
	if(current_hit_times >= hit_times):
		_on_obtained()
		eventsManager.OnSkillObtained.disconnect(_check_obtained)
			


