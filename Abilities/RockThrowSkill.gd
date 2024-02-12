extends Skill

func _setup_condition():
	eventsManager.OnPickUpStone.connect(_on_obtained)


