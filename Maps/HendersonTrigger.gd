extends "res://Maps/ReginaldTrigger.gd"
func _ready():
	super()
	var key = "HendersonDead"
	if(saveManager.loaded_data.has(key) && saveManager.loaded_data[key] == true):
		queue_free()
	else:
		eventsManager.OnHendersonDeath.connect(func():
			saveManager.add_data("HendersonDead", true)
			queue_free()
		)

	
