extends AIState

class_name Spawn_back_up_state


var amount_solid
var amount_gatherers
var max_solid
var max_gatherer
var cost_solid
var cost_gatherer
var animTransitionOnStart
var animTransitionOnEnd
var animTransitionOnEnd2
var animator

func setup_vars(p_max_solid, p_max_gatherer, p_cost_solid, p_cost_gatherer,
p_animator,p_animTransStart,p_animTransEnd,p_animTransEnd2):
	max_solid = p_max_solid
	max_gatherer = p_max_gatherer
	cost_solid = p_cost_solid
	cost_gatherer = p_cost_gatherer
	animTransitionOnStart = p_animTransStart
	animTransitionOnEnd = p_animTransEnd
	animTransitionOnEnd2 = p_animTransEnd2
	animator = p_animator

func _pre_setup():
	setup(new_slimes_needed,spawn_slimes,2)
func _on_enter():
	AnimatorHelper._playanimTransition(animator,animTransitionOnStart)
	
func _on_exit():
	AnimatorHelper._playanimTransition(animator,animTransitionOnEnd)
	AnimatorHelper._playanimTransition(animator,animTransitionOnEnd2)
func enough_mana():
	return ai.stats.mana > cost_solid || ai.stats.mana > cost_gatherer	
	
func new_slimes_needed():
	#if(ai.solid_slimes.size() < max_solid):
		
	#if(ai.gatherer_slimes.size() < max_gatherer):
	amount_solid = max_solid - ai.solid_slimes.size()
	amount_gatherers = max_gatherer - ai.gatherer_slimes.size()
	
	return (amount_solid > 0 || amount_gatherers > 0) && enough_mana()
		
func spawn_solid():
	amount_solid = max_solid - ai.solid_slimes.size()
	
	if(ai.stats.mana - cost_solid  < 0.0 || amount_solid <= 0 ):
		return
	var solid = ai.solid_slime.instantiate()
	ai.get_parent().add_sibling(solid)
	solid.global_position = ai.global_position
	var mob_ai_solid = solid.get_node("AI")
	mob_ai_solid.commander_ai = ai
	mob_ai_solid.reset_pos = ai.global_position
	ai.stats.mana -= cost_solid
	ai.solid_slimes.append(mob_ai_solid)
	return solid
func spawn_gatherer():
	
	if(ai.stats.mana - cost_gatherer  < 0.0 || amount_gatherers <= 0):
		return	
	var gatherer = ai.gatherer_slime.instantiate()
	ai.get_parent().add_sibling(gatherer)
	gatherer.global_position = ai.global_position
	var mob_ai_gatherer = gatherer.get_node("AI")
	mob_ai_gatherer.commander_ai = ai
	mob_ai_gatherer.reset_pos = ai.global_position
	ai.stats.mana -= cost_gatherer
	ai.gatherer_slimes.append(mob_ai_gatherer)
	return gatherer
func spawn_slimes():
	amount_gatherers = max_gatherer - ai.gatherer_slimes.size()
	amount_solid = max_solid - ai.solid_slimes.size()

	#for i in range(amount_solid):

		
	#for i in range(amount_gatherers):

