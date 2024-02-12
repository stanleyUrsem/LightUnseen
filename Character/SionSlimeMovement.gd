extends "res://Character/SionMovement.gd"
@export var brake_multiplier = 0.9
@export var roll_max = 1.0
#1100	1
#3000	3000/1100
var max_speed
func _ready():
	super()
	AnimatorHelper._playanimTreeOneShot(animChar._animator,"Transform", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	max_speed = SPEED

func set_max_speed(value : float):
	max_speed = SPEED * value
func reset_max_speed():
	max_speed = SPEED
	
func apply_velocity(value):
	velocity = value
	move_and_slide()
func _setVelocity(value):
	#var x_highest = value.x > value.y
	#var valid_ratio = value.y != 0 if x_highest else value.x != 0
	#var ratio = 0
	#if(valid_ratio):
		#ratio = value.x / value.y if x_highest else value.y / value.x
		#
	velocity += value
	var x_clamped = clampf(velocity.x,-max_speed,max_speed)
	var y_clamped = clampf(velocity.y,-max_speed,max_speed)
	var clamped_velocity = Vector2(x_clamped,y_clamped)
	velocity = clamped_velocity
	
	#velocity.x = x_clamped if x_highest else ratio * y_clamped
	#velocity.y = ratio * x_clamped if x_highest else y_clamped
	#
	#print("clamped: %f\t%f\nratio: %f\nvalue: %v\nvelocity: %v" %
	#[x_clamped,y_clamped,ratio,value,velocity])
	#velocity.y = ratioXtoY * velocity.x
	move_and_slide()

func _move():
	velocity *= brake_multiplier
	super()
	
