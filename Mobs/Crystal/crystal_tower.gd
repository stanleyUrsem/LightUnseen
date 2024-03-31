extends AnimatableMovableSkill

@export var duration_range : Vector2
@export var particle_temp : PackedScene
@export var spawn_loc : Marker2D
var current_time
var landed
func _on_setup():
	current_time = prng.range_f(duration_range.x,duration_range.y)
	landed = false

func _physics_process(delta):
	if(isSetup):
		current_time -= delta
		if(current_time <= 0):
			current_time = prng.range_f(duration_range.x,duration_range.y)
			if(landed):
				shoot()
			else:
				land()
	super(delta)

func land():
	AnimatorHelper._playanimTreeBlend2D(animTree,"Throw",1.0)
	landed = true
func shoot():
	AnimatorHelper._playanimTreeOneShotFire(animTree,"Shoot")
func create_particle():
	var dir = prng.random_unit_circle_random_degrees(false,Vector2(-90.0,90.0))
	var particle = particle_temp.instantiate()
	particle._setup_vars(speed,damage)
	particle._setup(spawn_loc ,user , dir,prng)
	user.add_child(particle)

func _OnHit(collision, is_cast = false):
	return



