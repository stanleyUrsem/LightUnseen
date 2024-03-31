extends "res://Character/SionMovement.gd"
@export var brake_multiplier = 0.9
@export var lowest_velocity = 0.01
@export var roll_max = 1.0
@export var current_velocity : Vector2
#1100	1
#3000	3000/1100
@export var max_speed : float

var saved_max_speed : float

func _ready():
	super()
	AnimatorHelper._playanimTreeOneShot(animChar._animator,"Transform", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	saved_max_speed = max_speed
func set_max_speed(value : float):
	max_speed = saved_max_speed * value
func reset_max_speed():
	max_speed = saved_max_speed
	
func zero_out_velocity():
	if(abs(velocity.x) < lowest_velocity):
		velocity.x = 0.0
	if(abs(velocity.y) < lowest_velocity):
		velocity.y = 0.0
func _set_roll_velocity(x):
	zero_out_velocity()
	super(x)
func apply_velocity(value):
	velocity = value
	move_and_slide()
func _setVelocity(value):
	if(value.x == 0.0):
		velocity.x *= brake_multiplier
	if(value.y == 0.0):
		velocity.y *= brake_multiplier
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
	#print("pre-clamp: %v\nclamped: %v"  % [velocity,clamped_velocity])
	velocity = clamped_velocity
	current_velocity = velocity	
	#velocity.x = x_clamped if x_highest else ratio * y_clamped
	#velocity.y = ratio * x_clamped if x_highest else y_clamped
	#
	#print("clamped: %f\t%f\nratio: %f\nvalue: %v\nvelocity: %v" %
	#[x_clamped,y_clamped,ratio,value,velocity])
	#velocity.y = ratioXtoY * velocity.x
	move_and_slide()

func _move():
	super()
	move_and_slide()
	
