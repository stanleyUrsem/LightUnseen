extends AIState

class_name MoveToPointState

var search_state :SearchState

func _pre_setup():
	setup(func():
#		print("\nfood point is: ", foodPoint.z, "\nmove to food: ", foodPoint.z > 0.0)
		return search_state.foodPoint.z > 0.0,
		func(): ai.mobMovement.moveToPoint(search_state.point),1)

func setup_vars(p_search_state: SearchState):
	search_state = p_search_state


func _on_enter():
	ai.mobMovement.resetMovement()
	anims._walk()
