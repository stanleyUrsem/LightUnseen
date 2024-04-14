extends CharacterMovement
class_name MobMovement

var dashTween
var dashVelocity
var dashDuration
@export var stopMovement : bool
@export var wallCast : ShapeCast2D
var last_pos : Vector2
var prng : PRNG
var amount_called : int

func _ready():
	super()
	prng = PRNG.new(123091823)
	last_pos = global_position


func resetMovement():
	velocity = Vector2.ZERO

# Move to target
func moveToTarget(target: Node2D):
	var parent = target.get_parent() as Node2D
	var pos = parent.position
	moveToPoint(pos)
	

	
func moveToPoint(point, speed_multiplier = 1.0, normalize = true):
	var delta = ((point) - global_position)
	if(normalize):
		delta = delta.normalized()
		velocity = delta * SPEED * speed_multiplier
	else:
		velocity = delta * speed_multiplier
	_turn(velocity.x)

# Move to random points in area
func moveRandom(rot, length):
	var pos = Vector2(cos(rot),sin(rot)) * length
	moveToPoint(pos)


func _setVelocityHorizontal(value: Vector3):
	var x = min(value.x, SPEED * value.z)
	var y = min(value.y, SPEED * value.z)
	velocity = Vector2(x,y)
	move_and_slide()

func dashTo(point):
	var delta = (position - point).normalize()
	var velo = delta * (dashVelocity)
	dashTween = get_tree().create_tween()
	dashTween.set_trans(Tween.TRANS_EXPO)
	dashTween.set_ease(Tween.EASE_IN_OUT )
	dashTween.tween_method(
	_setVelocityHorizontal,
	Vector3(0,0,0),
	Vector3(velo.x,velo.y,dashVelocity),
	dashDuration)

func evade():
	pass


func _physics_process(delta):
#	pass
	if(stopMovement):
		return
	var collided = move_and_slide()
	#if(collided):
		#var hit = get_last_slide_collision().get_collider()
		#print("Slided against: ", hit.name)

