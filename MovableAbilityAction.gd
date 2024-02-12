extends AbilityAction

class_name MovableAbilityaction

@export var animBody : AnimatableBody2D

func _on_setup():
	super()
	
func _physics_process(delta):
	super(delta)
	if(isSetup):
		_Move()

func _Move():
	var collision = animBody.move_and_collide(data.speed *direction)
	
	if(collision != null && collision.get_collider().get_parent() != user):
		_OnHit(collision)
