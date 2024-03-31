extends Surround_target_state

class_name Defense_Line_State


func _target_valid():
	return hp_low()

func surround_target():
	target = ai.get_parent()
	super()
	
func hp_low():
	return ai.stats.hp <= ai.stats.hp_max * 0.50
	
