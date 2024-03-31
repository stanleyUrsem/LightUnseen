extends SkillAction

@export var animBody : AnimatableBody2D


func _physics_process(delta):
	super(delta)
	if(isSetup):
		_Move()

func _Move():
	var collision = animBody.move_and_collide(speed * direction)
	
	if(collision != null && collision.get_collider().get_parent() != user):
		_OnHit(collision)
