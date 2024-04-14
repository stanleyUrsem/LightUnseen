extends AIState

class_name SearchPlayerState

var sightCast
var wanderState : WanderState

var searchTransition
var stopAttackTransition
var stopAttackLoopTransition
func _pre_setup():
	setup(func():
#		print("inv: ", stats.inv_space, "\n", stats.inv_space > lowInv)
		return (ai.stats.stamina > ai.stats.stamina_max/2.0)
		,searchForPlayer,3)

func setup_vars(p_sightCast:ShapeCast2D, p_wanderState: WanderState,
p_searchTransition, p_stopAttackTransition,p_stopAttackLoopTransition ):
	sightCast = p_sightCast
	wanderState = p_wanderState
	searchTransition = p_searchTransition
	stopAttackTransition = p_stopAttackTransition
	stopAttackLoopTransition = p_stopAttackLoopTransition

func _on_enter():
	AnimatorHelper._playanimTransition(ai.animTree,searchTransition)

func _on_exit():
	super()
	AnimatorHelper._playanimTransition(ai.animTree,stopAttackTransition)
	AnimatorHelper._playanimTransition(ai.animTree,stopAttackLoopTransition)

func searchForPlayer():
	if(!sightCast.is_colliding()):
		wanderState.wander(0.5,0.1)
		return
	
	var valid_cols = sightCast.collision_result
	var dist = 999.0
	var pos
	var col
	#Check each collider for slimes or player
	for i in sightCast.get_collision_count():
		var valid_col = sightCast.get_collider(i) as CollisionObject2D
		
		#Other slimes found the player
		if(valid_col.get_parent().name == "MobSpawner"):
			var mobAi = valid_col.get_node("AI") as SlimeAI
			if(mobAi.player != null):
				ai.player = mobAi.player
			called_amount += 1
			return
		if(valid_col.get_collision_layer_value(5)):
			#The player is found already
			pos = valid_col.global_position
			ai.player = valid_col
			called_amount += 1
			return
	called_amount += 1
	
	#if(dist < 999.0):
		#foodPoint = Vector3(pos.x,pos.y,1.0)
		#foodCollision = col
		#print("food point set ", foodPoint)
	#else:
		#foodPoint = Vector3(0,0,0)
