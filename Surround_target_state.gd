extends AIState

class_name Surround_target_state


var size
var target : Node2D
func setup_vars(p_size):
	size = p_size

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
		var dir = pos
		pos *= size
		pos += target.global_position
		ai.solid_slimes[index].move_to(pos)
		ai.solid_slimes.attack_forward(dir)
		index += 1
	index = 0
	for pos in line_positions:
		if(index >= ai.gatherer_slimes.size()):
			break
		pos *= size
		pos += target.global_position
		ai.gatherer_slimes[index].move_to(pos)
		ai.gatherer_slimes[index].attack_forward(Vector2.DOWN)
		index += 1
	
