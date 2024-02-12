extends AIState


class_name EscapeState

var min_dist
var flee_state : FleeState
var escape_point : Vector2:
	get:
		return flee_state.escape_point


func setup_vars(p_min_dist: float, p_flee_state):
	min_dist = p_min_dist
	flee_state = p_flee_state

func _pre_setup():
	setup(func():
		return ai.mobMovement.global_position.distance_to(escape_point) < min_dist
		,escape,5)
		
func escape():
	var mobSpawner = get_parent().get_parent()
	mobSpawner.respawn_timer(ai.mob_type)
	ai.queue_free()
