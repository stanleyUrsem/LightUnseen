extends Surround_target_state

class_name Defense_Line_State






func _target_valid():
	return hp_low() && enough_slimes() && current_cooldown > 0

func surround_target():
	target = ai.get_parent()
	super()
	
func hp_low():
	return ai.stats.health <= ai.stats.health_max * 0.50
	
