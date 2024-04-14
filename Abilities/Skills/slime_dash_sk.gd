extends Skill

class_name slime_dash_sk

var hit_times : int
var current_hit_times : int
var form_needed : int
var player_transform : PlayerTransformer
var correct_form : bool

func _setup_vars(p_hit_times, p_form, p_player_transform):
	hit_times = p_hit_times
	form_needed = p_form
	player_transform = p_player_transform
func load_vars(loaded_data):
	var key = "%s_hit_times" % skillData.displayName
	if(!loaded_data.has(key)):
		return
	current_hit_times = loaded_data[key]
	if(current_hit_times >= hit_times):
		_on_obtained()
		_disable_obtain_event()
func _setup_obtain_event():
	player_transform.on_form_changed.connect(on_player_transform)
	eventsManager.OnHitBy.connect(_check_obtained)
func _disable_obtain_event():
	player_transform.on_form_changed.disconnect(on_player_transform)
	eventsManager.OnHitBy.disconnect(_check_obtained)	
func on_player_transform(form):
	correct_form = player_transform.current_form == form_needed
func save_vars():
	saveManager.add_data("%s_hit_times" % skillData.displayName,current_hit_times)		
func _check_obtained(type, damage):
	if(obtained):
		return
	
	if(!correct_form):
		return
	current_hit_times += 1.0
	save_vars()
	eventsManager.OnSkillProgress.emit(self,float(current_hit_times)/float(hit_times))
	if(current_hit_times >= hit_times):
		_on_obtained()
		eventsManager.OnHitBy.disconnect(_check_obtained)
			


