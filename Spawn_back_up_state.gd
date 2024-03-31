extends AIState

class_name Spawn_back_up_state


var amount_solid
var amount_gatherers
var max_solid
var max_gatherer
var cost_solid
var cost_gatherer
func setup_vars(p_max_solid, p_max_gatherer, p_cost_solid, p_cost_gatherer):
	max_solid = p_max_solid
	max_gatherer = p_max_gatherer
	cost_solid = p_cost_solid
	cost_gatherer = p_cost_gatherer

func _pre_setup():
	setup(new_slimes_needed,spawn_slimes,2)

func new_slimes_needed():
	if(ai.solid_slimes.size() < max_solid):
		amount_solid = max_solid - ai.solid_slimes.size()
		
	if(ai.gatherer_slimes.sizes() < max_gatherer):
		amount_gatherers = max_gatherer - ai.gatherer_slimes.size()
	
	return amount_solid > 0 || amount_gatherers > 0
		
	
func spawn_slimes():
	for i in range(amount_solid):
		if(ai.stats.mana - cost_solid  < 0.0):
			return
		var solid = ai.solid_slime.instantiate()
		solid.global_position = ai.global_position
		ai.stats.mana -= cost_solid
		
	for i in range(amount_gatherers):
		if(ai.stats.mana - cost_gatherer  < 0.0):
			return
		var gatherer = ai.gatherer_slime.instantiate()
		gatherer.global_position = ai.global_position
		ai.stats.mana -= cost_gatherer
