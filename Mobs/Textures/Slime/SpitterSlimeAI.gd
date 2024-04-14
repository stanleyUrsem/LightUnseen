extends "res://GathererSlimeAI.gd"


func _physics_process(delta):
	super(delta)
	scan_for_player()
func scan_for_player():
	if(sightCast.is_colliding()):
		for i in sightCast.get_collision_count():
			var col = sightCast.get_collider(i)
			if(col == null):
				continue
			_OnPlayerFound(col)
			return

func _OnPlayerFound(col):
	super(col)
	attackState.chance = 10
