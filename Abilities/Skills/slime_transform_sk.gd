extends Skill

class_name slime_transform_sk

var blue_slime_needed : int
var blue_slime_type : int
var blue_slime_defeated : int

func _setup_vars(p_blue_slime_needed,p_blue_slime_type):
	blue_slime_needed = p_blue_slime_needed
	blue_slime_type = p_blue_slime_type

func _setup_obtain_event():
	eventsManager.OnEnemyKilled.connect(add_defeated)
func _disable_obtain_event():
	eventsManager.OnEnemyKilled.disconnect(add_defeated)
	
func add_defeated(type):
	if(obtained):
		return
		
	if(type == blue_slime_type):
		blue_slime_defeated += 1
	if(blue_slime_defeated >= blue_slime_needed):
		eventsManager.OnEnemyKilled.disconnect(add_defeated)
		_on_obtained()



