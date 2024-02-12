extends CharacterMovement
@export var transform_index : int
@export var player_transformer : PlayerTransformer
@export var dodgeVelocity = 6000.0
@export var dodgeDuration = 0.4
@export var rollVelocity = 5.0
@export var rollDuration = 0.5
@export var stopMovement = false
@export var rollCurve : Curve
@export var dodgeCurve : Curve
var rollTween
var dodgeTween
var art_node
func _ready():
	art_node = get_node("Art")
	stopMovement = false
	animChar = SionTDAnimations.new()
	animChar._setup(get_node("AnimationTree"))
	
func _move():
	super()
	var vertical = Input.get_axis("move_up", "move_down")
#	velocity.y = vertical * SPEED if vertical else move_toward(velocity.y, 0, SPEED);
	#velocity.y = vertical;
	var current_vel = Vector2(horizontal,vertical)
	_setVelocity(current_vel.normalized() * SPEED)
	#velocity = velocity.normalized() * SPEED
	_idleOrWalk(Vector2(vertical,horizontal).length())
#	print(velocity)

func _physics_process(delta):
	if(stopMovement): return
	
	#_mobility()
	_move()
	#_transform()
	#move_and_slide()
#	_attacks()
func _set_dodge_velocity(x):
	var new_velocity = lerp(Vector2.ZERO, get_end_velocity(dodgeVelocity),dodgeCurve.sample(x))
	_setVelocity(new_velocity)
	
func _set_roll_velocity(x):
	
	var new_velocity = lerp(velocity, get_end_velocity(rollVelocity),rollCurve.sample(x))
	
	_setVelocity(new_velocity)
	
func _setVelocity(value: Vector2):
#	print("\nVelocity set:", velocity)
	velocity = value
	move_and_slide()

func get_end_velocity(velo_max):
	var max = SPEED * velo_max
#	var endVelocityX = clamp(velocity.x * (velo_max),-max,max)
#	var endVelocityY = clamp(velocity.y * (velo_max),-max,max)
##	print("\nvelocity: ",velocity,"\nMax: ",max,"\nX: ", endVelocityX,"\nY: ",endVelocityY)
#	if(velocity.x <= 0.0 && velocity.y <= 0.0):
#		return Vector2.LEFT * (max * (1 if animChar.turnCurrent > 0 else -1))
#	return Vector2(endVelocityX,endVelocityY)
	var dir = velocity.normalized()
	if(velocity.length() == 0):
		dir = Vector2.RIGHT * art_node.scale
	return (SPEED * velo_max * dir)
func reset_velocity():
	velocity = Vector2.ZERO
func dodge():
	if(dodgeTween != null && dodgeTween.is_valid()):
			dodgeTween.kill()
			return;
	#animChar._dodge()
	dodgeTween = get_tree().create_tween()
	dodgeTween.tween_method(_set_dodge_velocity,0.0,1.0,dodgeDuration)
	dodgeTween.tween_callback(reset_velocity)

func roll():
	if(rollTween != null && rollTween.is_valid()):
		rollTween.kill()
		return;
		
	#animChar._roll()
	rollTween  = get_tree().create_tween()
	rollTween.tween_method(_set_roll_velocity,0.0,1.0,rollDuration)
	rollTween.tween_callback(reset_velocity)	
	
#func _mobility():
	#if Input.is_action_just_pressed("dodge"):
		#if(dodgeTween != null && dodgeTween.is_valid()):
			#dodgeTween.kill()
			#return;
		#animChar._dodge()
		#dodgeTween = get_tree().create_tween()
		#dodgeTween.tween_method(_set_dodge_velocity,0.0,1.0,dodgeDuration)
		#dodgeTween.tween_callback(reset_velocity)
	#if Input.is_action_just_pressed("roll"):
		#if(rollTween != null && rollTween.is_valid()):
			#rollTween.kill()
			#return;
		#
		#animChar._roll()
		#rollTween  = get_tree().create_tween()
		#rollTween.tween_method(_set_roll_velocity,0.0,1.0,rollDuration)
		#rollTween.tween_callback(reset_velocity)
		#

func _transform(index:int):
	if(index == transform_index):
		return
	player_transformer._set_form(index)
	#if Input.is_action_just_pressed("Slime_Transform"):
	#player_transformer._set_form(1)
	#if Input.is_action_just_pressed("Human_Transform"):
	#player_transformer._set_form(0)

func _attacks():
	if Input.is_action_just_pressed("attack"):
		animChar._attack()
	if Input.is_action_just_pressed("lr_attack"):
		animChar._lrattack()

