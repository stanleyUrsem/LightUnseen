extends Skill

class_name slime_transform_sk

var blue_slime_needed : int
var blue_slime_type : int
var blue_slime_defeated : int

func _setup_vars(p_blue_slime_needed,p_blue_slime_type):
	blue_slime_needed = p_blue_slime_needed
	blue_slime_type = p_blue_slime_type
func load_vars(loaded_data):
	var key = "blue_slime_defeated"
	if(!loaded_data.has(key)):
		return
	blue_slime_defeated = loaded_data[key]
	if(blue_slime_defeated >= blue_slime_needed):
		_on_obtained()
		_disable_obtain_event()
func _setup_obtain_event():
	eventsManager.OnEnemyKilled.connect(add_defeated)
func _disable_obtain_event():
	eventsManager.OnEnemyKilled.disconnect(add_defeated)
func save_vars():
	saveManager.add_data("blue_slime_defeated",blue_slime_defeated)	
func add_defeated(type):
	if(obtained):
		return
		
	if(type == blue_slime_type):
		blue_slime_defeated += 1.0
		save_vars()
		eventsManager.OnSkillProgress.emit(self,
		blue_slime_defeated/float(blue_slime_needed))
	if(blue_slime_defeated >= blue_slime_needed):
		eventsManager.OnEnemyKilled.disconnect(add_defeated)
		_on_obtained()



