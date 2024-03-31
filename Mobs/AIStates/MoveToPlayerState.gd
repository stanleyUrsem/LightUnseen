extends AIState

class_name MoveToPlayerState


func _pre_setup():
	setup(func():
#		print("\nfood point is: ", foodPoint.z, "\nmove to food: ", foodPoint.z > 0.0)
		return ai.player != null,
		func(): 
			if(ai.player != null):
				ai.mobMovement.moveToPoint(ai.player.global_position),
				1)


func _on_enter():
	ai.mobMovement.resetMovement()
	anims._walk()
