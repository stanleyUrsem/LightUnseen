extends Skill



class_name mobs_defeated_sk

var type_hits_defeated : Dictionary


func _setup_vars(hits_types):
	for i in hits_types.size():
		var hits_type = hits_types[i]
		type_hits_defeated[hits_type.y] = Vector2i(hits_type.x,0)

func _setup_obtain_event():
	eventsManager.OnEnemyKilled.connect(add_defeated)
func _disable_obtain_event():
	eventsManager.OnEnemyKilled.disconnect(add_defeated)	
func add_defeated(type):
	if(obtained):
		return
	
	if(!type_hits_defeated.has(type)):
		return
	type_hits_defeated[type].y += 1
	#if(type == blue_slime_type):
		#blue_slime_defeated += 1
	#if(type == red_slime_type):
		#red_slime_defeated += 1
	var completed = 0
	for key in type_hits_defeated:
		var hits_defeated = type_hits_defeated[key]	
		if(hits_defeated.y >= hits_defeated.x):
			completed += 1
	#if(blue_slime_defeated >= blue_slime_needed && red_slime_defeated >= red_slime_needed):
	if(completed == type_hits_defeated.size()):
		eventsManager.OnEnemyKilled.disconnect(add_defeated)
		_on_obtained()



