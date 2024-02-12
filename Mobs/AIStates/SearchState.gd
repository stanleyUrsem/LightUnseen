extends AIState

class_name SearchState

var sightCast
var wanderState : WanderState
var lowInv

var foodPoint : Vector3
var foodCollision : Object
var point : Vector2:
	get:
		return Vector2(foodPoint.x, foodPoint.y)


func _pre_setup():
	setup(func():
#		print("inv: ", stats.inv_space, "\n", stats.inv_space > lowInv)
		return (ai.stats.inv_space > lowInv &&
		ai.stats.stamina > ai.stats.stamina_max/2.0)
		,searchForFood,1)

func setup_vars(p_sightCast:ShapeCast2D, p_wanderState: WanderState, p_lowInv: int):
	sightCast = p_sightCast
	wanderState = p_wanderState
	lowInv = p_lowInv

func searchForFood():
	if(!sightCast.is_colliding()):
		wanderState.wander(2.0,0.1)
		return
	
	var valid_cols = sightCast.collision_result
	var dist = 999.0
	var pos
	var col
	
	for i in sightCast.get_collision_count():
		var valid_col = sightCast.get_collider(i)
		var cpos = (valid_col.global_position)
		var globPos = ai.mobMovement.global_position
		var globPosMove = ai.mobMovement.to_global(ai.mobMovement.position)
		var posDist = globPos.distance_to(cpos)

		if(posDist < dist):
			pos = cpos
			col = sightCast.get_collider(i)
			dist = posDist
	
	if(dist < 999.0):
		foodPoint = Vector3(pos.x,pos.y,1.0)
		foodCollision = col
		print("food point set ", foodPoint)
	else:
		foodPoint = Vector3(0,0,0)
