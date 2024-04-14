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
			land()
			#if(landed):
				#shoot()
			#else:
	super(delta)

func land():
	isSetup = false
	#speed = 0
	AnimatorHelper._playanimTreeBlend2D(animTree,"Impact",1.0)
	#landed = true
func shoot():
	#isSetup = false
	AnimatorHelper._playanimTreeOneShotFire(animTree,"Shoot")
func create_particle():
	var dir = Vector2.UP * prng.range_f(-1.0,1.0)
	if(user == null):
		return
	if(user.player != null):
		var player_dir = user.player.global_position - spawn_loc.global_position
		dir += player_dir.normalized()
		
	
	var particle = particle_temp.instantiate()
	#user.get_parent().add_sibling(particle)
	get_tree().root.get_child(0).add_child(particle)
	particle._setup_vars(speed,damage)
	particle._setup(spawn_loc.global_position ,user , dir,prng)
	#particle.global_position = spawn_loc.global_position

func _OnHit(collision, is_cast = false):
	return



