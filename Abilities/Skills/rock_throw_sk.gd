extends Skill

class_name rock_throw_sk



func _setup_obtain_event():
	eventsManager.OnPickUpStone.connect(_check_obtained)
func _disable_obtain_event():
	eventsManager.OnPickUpStone.disconnect(_check_obtained)
	
func _check_obtained():
		if(obtained):
			return
			
		_on_obtained()
		eventsManager.OnPickUpStone.disconnect(_check_obtained)
			


