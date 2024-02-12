extends MovableAbilityaction
@export var animTree : AnimationTree
@export var animPlayer : AnimationPlayer
@export var spawn_points : Array[Marker2D]
@export var slime_particle : PackedScene
@export var amount_loops : int

var current_loops : int
var saved_direction
var reflected_direction
var reflect_tween : Tween
func _on_setup():
	super()
	current_loops = 0
	AnimatorHelper._setSpeedScale(animTree,"Speed", data.speed)
	#saved_direction = direction
	
func add_loop():
	current_loops += 1
	if(current_loops > amount_loops):
		current_loops = 0
		AnimatorHelper._playanimTreeOneShot(animTree,"End",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		AnimatorHelper._playanimTreeOneShot(animTree,"Loop",AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		_fadeout()



func _OnHit(collision):
	if(isHit):
		return
	super(collision)
	_ApplyDamage(collision)
	if(collision is KinematicCollision2D):
		#var reflect = collision.get_remainder().bounce(collision.get_normal())
		var reflect = direction.bounce(collision.get_normal())
		reflected_direction = reflect
		reflect()

func reflect():
	if(reflect_tween != null && reflect_tween.is_running()):
		reflect_tween.kill()
	var duration = prng.range_f(0.5,1.5)
	reflect_tween = get_tree().create_tween()
	reflect_tween.tween_method(set_direction,Vector2.ZERO,reflected_direction,duration)
	reflect_tween.tween_method(set_direction,Vector2.ZERO,-reflected_direction,duration)
	

func set_direction(dir):
	direction = dir

func create_slime_particle(spawn_index: int,move_dir:Vector2):
	var spawn_node = get_tree().root.get_child(0)
	var slime = slime_particle.instantiate() as MovableAbilityaction
	spawn_node.add_child(slime)
	slime._setup(null,spawn_points[spawn_index].global_position,
	user,mouseHandler,move_dir,prng)
	slime.damage = data.damage / spawn_points.size()
