extends CharacterBody2D

class_name CharacterMovement

@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animChar : AnimatableCharacter
var horizontal
func _ready():
	animChar = AnimatableCharacter.new()
	animChar._setup(get_node("AnimationTree"))

func _turn(direction):
	if(direction > 0 ):
		animChar._turn(-1)
	elif(direction < 0):
		animChar._turn(1)

func _idleOrWalk(direction):
	if(direction > 0 || direction < 0):
		animChar._walk()
	else:
		animChar._idle()

func _move():
	horizontal = Input.get_axis("move_left", "move_right")
	_turn(horizontal)
	_idleOrWalk(horizontal)
	
#	velocity.x = horizontal * SPEED if horizontal else move_toward(velocity.x, 0, SPEED)  ;
	#velocity.x = horizontal;





