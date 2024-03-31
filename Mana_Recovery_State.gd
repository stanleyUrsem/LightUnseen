extends AIState

class_name Mana_Recovery_State

var mana_recovery
var mana_low_amount
var recovering : bool
var recover_delay
var current_delay
var delta

func setup_vars(p_mana_low, p_mana_recovery):	
	mana_low_amount = p_mana_low
	mana_recovery = p_mana_recovery
	recovering = false
	current_delay = 0.0
	
func _pre_setup():
	setup(mana_low,recover_mana,3)


func mana_low():
	return ai.stats.mana <= mana_low_amount

func recover_mana():
	ai.idle()
	delta = ai.delta
	current_delay -= delta
	if(current_delay <= 0.0):
		current_delay = recover_delay
		ai.stats.mana += mana_recovery 
	

