extends MovableAbilityaction

@export var xCurve : Curve
@export var yCurve : Curve
@export var anim : AnimationPlayer
@export var add_angle : float
@export var steps_ahead : float
#@export_file() var pool : String
var endPos
var beginPos
var dist
var t
var t_speed
#var slime_pool
func _on_setup():
	#slime_pool = load(pool)
	var offset = prng.random_unit_area(true) * prng.range_f_v(direction)
	endPos = mouseHandler.mouseGlobalPos + offset
	beginPos = global_position
	dist = beginPos.distance_to(endPos)
	t_speed = data.speed/dist
	direction = Vector2.ZERO
	anim.play("new_animation")
	t = 0.0

func get_pos(alpha)-> Vector2:
	var pos : Vector2
	pos.x = lerp(beginPos.x, endPos.x,xCurve.sample(alpha))
	pos.y = lerp(beginPos.y, endPos.y,yCurve.sample(alpha))
	return pos

func set_angle(alpha, nextAlpha):
	var nextPos = get_pos(min(1.0,nextAlpha))
	var pos = get_pos(alpha)
	var dir = (nextPos-pos).normalized()
	#rotation_degrees = HelperFunctions.get_velocity_angle(dir) + add_angle
	rotation_degrees = HelperFunctions.get_angle(nextPos,pos) + add_angle

func _Move():
	if(t >= 1.0):
		return
	var new_t = t + (t_speed * delta_time)
	set_angle(t,new_t)
	t = new_t
	global_position = get_pos(t)
	if(t >= 1.0):
		remove()
	super()

#func create_pool(pos):
func remove():
	#var pool = slime_pool.instantiate() as AbilityAction
	#pool._setup(data,pos,user.get_parent(),null,Vector2.ZERO,prng)
	#pool.global_position = pos
	##pool._setup(prng,data.damage)
	##pool.global_position = pos
	#user.get_parent().add_child(pool)
	queue_free()

func _OnHit(collision,is_cast=false):
	super(collision,is_cast)
	var pos = collision.get_position()
	remove()
