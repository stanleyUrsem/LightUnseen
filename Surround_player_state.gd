extends Surround_target_state

class_name Surround_player_state


	
func _target_valid():
	return player_found() && enough_slimes() && current_cooldown > 0

func surround_target():
	target = ai.player
	super()



func player_found():
	if(ai.player != null):
		return true
		
	for spawned_ai in ai.solid_slimes:
		if(spawned_ai.player != null):
			return true
	
	for spawned_ai in ai.gatherer_slimes:
		if(spawned_ai.player != null):
			return true
			
	return false
