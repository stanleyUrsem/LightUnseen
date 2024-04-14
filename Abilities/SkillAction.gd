extends Node2D

class_name SkillAction

@export var fadeTimer : Timer
@export var detectCollisions : bool
@export var piercing : bool
@export var shapeCast : ShapeCast2D
@export var body : PhysicsBody2D
var damage
var isSetup : bool
var isHit : bool
var direction
var user : Node2D
var saved_fade
var delta_time
var collision_result
var prng : PRNG
var hit_pos
var is_mob
var hitNumberManager
var speed : float
var cols_hit : Array

var time_alive : float

func _setup_vars(p_speed, p_damage):
	speed = p_speed
	damage = p_damage
	
	
func _setup(useLocation , p_user : Node2D, p_direction,p_prng):
	hitNumberManager = get_node("/root/MAIN/HitNumberManager")
	user = p_user
	prng = p_prng
	position = useLocation
	direction = p_direction
	isSetup = true
	isHit = false
	is_mob = false
	saved_fade = fadeTimer.wait_time
	fadeTimer.timeout.connect(_fade)
	_on_setup()

func _on_setup():
	pass
func _detect_collision():
	if(isSetup && detectCollisions && shapeCast.is_colliding()):
		return shapeCast.get_collision_count()
	else:
		return 0
		


func _Move():
	var collision = body.move_and_collide(speed * direction,speed > 0.0)
	
	if(collision != null && collision.get_collider().get_parent() != user):
		_OnHit(collision)

func _physics_process(delta):
	delta_time = delta
	time_alive += delta
	
	if(time_alive > 10.0):
		_fade()
		return
	
	if(isSetup && body != null):
		_Move()
	check_collision()
func check_collision():
	if(shapeCast == null):
		return
	collision_result = _detect_collision()
	if(collision_result > 0):
		for i in shapeCast.get_collision_count():
			var valid_col = shapeCast.get_collider(i)
			if(valid_col == null || cols_hit.has(valid_col)):
				continue
			cols_hit.append(valid_col)
			_OnHit(valid_col,true)
			if(piercing):
				isHit = false
func _fadeout(time : float = 0):
	if(time > 0):
		fadeTimer.start(time)
	else:
		fadeTimer.start(saved_fade)
		
func _ShowHit():
	hitNumberManager.onHit(hit_pos,damage,is_mob)

func get_hit(collision,is_cast=false):
	if(collision == null):
		return null
	var hit
	if(is_cast):
		hit = collision.get_node_or_null("Hittable")
		return hit
	hit = collision.get_collider().get_node_or_null("Hittable")
	return hit

func _ApplyDamage(collision,is_cast=false):
	var hit = get_hit(collision,is_cast)
	if(hit is Hittable):
		hit.OnHit.emit(damage, user)
		hit_pos	= collision.global_position if is_cast else collision.get_position() 
		_ShowHit()
		return hit
	return null
func _fade(): 
	queue_free()
func _OnHit(collision,is_cast=false):
	if(isHit): 
		return null
	isHit = true
	return _ApplyDamage(collision,is_cast)
