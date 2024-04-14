extends "res://MovableSkill.gd"
@export var life_time : float
@export var speed_multiplier : float
@export var animTree : AnimationTree

var current_life_time : float

func _on_setup():
	current_life_time = life_time

func _OnHit(collision,is_cast=false):
	if(isHit):
		return
	super(collision,is_cast)
	if(collision is KinematicCollision2D):
		#var reflect = collision.get_remainder().bounce(collision.get_normal())
		var reflect = direction.bounce(collision.get_normal())
		direction = reflect
		speed *= speed_multiplier
		if(current_life_time <= 0.0):
			speed = 0.0
			AnimatorHelper._playanimTreeBlend2D(animTree,"Phase",1)
		else:
			AnimatorHelper._playanimTreeBlend2D(animTree,"Phase",-1)
		isHit = false

func _physics_process(delta):
	super(delta)
	
	if(current_life_time > 0.0):
		current_life_time -= delta
	
