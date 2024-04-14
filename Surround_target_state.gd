extends AIState

class_name Surround_target_state

var on_start : AnimationTransition
var on_end_one_shot : AnimationTransition
var on_end : AnimationTransition
var size
var target : Node2D
var current_cooldown : float
var cooldown : float

var solid_dist : float
var gatherer_dist : float
func setup_vars(p_size,p_surround_start,p_surround_one_shot,p_surround_end,
p_cooldown, p_solid_dist,p_gatherer_dist):
	size = p_size
	on_end = p_surround_end
	on_start = p_surround_start
	on_end_one_shot = p_surround_one_shot
	cooldown = p_cooldown
	current_cooldown = cooldown
	solid_dist = p_solid_dist
	gatherer_dist = p_gatherer_dist
	
func _on_enter():
	AnimatorHelper._playanimTransition(ai.slimeAnims._animator,
	on_start)
	
func _on_exit():
	AnimatorHelper._playanimTransition(ai.slimeAnims._animator,
	on_end)	
	AnimatorHelper._playanimTransition(ai.slimeAnims._animator,
	on_end_one_shot)
	
	for slime in ai.solid_slimes:
		if(slime == null):
			continue
		slime.reset_position()
	for slime in ai.gatherer_slimes:
		if(slime == null):
			continue
		slime.reset_position()
	current_cooldown = cooldown
	
func enough_slimes():
	
	return ai.solid_slimes.size() > 0 || ai.gatherer_slimes.size() > 0


func _pre_setup():
	setup(_target_valid,surround_target,2)

func _target_valid():
	return true



#[1] x: 0.5 y: 0.5 LB
#[2] x:-0.5 y: 0.5 RB
#[3] x: 0.5 y:-0.5 LT
#[4] x: -0.5 y:-0.5 RT

#[5] x: 0.0 y:-0.5 LB-RB
#[6] x:-0.5 y: 0.0 RB-RT
#[7] x: 0.0 y:-0.5 LT-RT
#[8] x: -0.5 y: 0.0 RT-RB
func surround_target():
	var positions = [Vector2(0.5,0.5),Vector2(-0.5,0.5),
					 Vector2(0.5,-0.5),Vector2(-0.5,-0.5),
					 Vector2(0.0,-0.5),Vector2(-0.5,0.0),
					 Vector2(0.0,-0.5),Vector2(-0.5,0.0)]
	var line_positions = [
		Vector2(1.0,-1.0),
		Vector2(1.5,-1.0),
		Vector2(-1.0,-1.0),
		Vector2(-1.5,-1.0)]
	var index = 0
	for pos in positions:
		if(index >= ai.solid_slimes.size()):
			break
		pos *= size
		if(target == null):
			return
		if(ai.solid_slimes[index] == null):
			index += 1
			continue
		pos += target.global_position
		var dir = target.global_position
		ai.solid_slimes[index].move_and_attack(pos,dir,solid_dist)
		index += 1
	index = 0
	for pos in line_positions:
		if(index >= ai.gatherer_slimes.size()):
			break
		pos *= size
		if(target == null):
			return
		if(ai.gatherer_slimes[index] == null):
			index += 1			
			continue
		pos += target.global_position
		var dir = target.global_position
		#ai.gatherer_slimes[index].move_to(pos)
		ai.gatherer_slimes[index].move_and_attack(pos,dir,gatherer_dist)
		index += 1
	
func target_update(delta):
	if(current_cooldown > 0):
		current_cooldown -= delta
