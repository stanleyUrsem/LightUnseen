extends MovableAbilityaction
@export var extra_dist : float
@onready var collider = $"CollisionShape2D"

@export var animTree : AnimationTree
@export var animPlayer : AnimationPlayer

func _setup(p_data : AbilityData, location, user, mouseHandler, p_direction, prng):
	super(p_data,location,user,mouseHandler, p_direction,prng)
	AnimatorHelper._setSpeedScale(animTree,"Speed", data.speed)
	AnimatorHelper._playanimTreeOneShot(animTree,"Fly",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


	
func _OnHit(collision):
	if(isHit):
		return
	var saved_dir = direction
	direction = Vector2.ZERO
	super(collision)
	var hit = _ApplyDamage(collision)
	#var hit = collision.get_collider().get_node_or_null("Collider")
	if(hit is Hittable):
		if(hit.type == 0):
			collider.disabled = true
			get_parent().remove_child(self)
			#global_position += saved_dir * extra_dist
			#print(direction)
			global_position -= hit.global_position
			#global_position += saved_dir * extra_dist
			#position = Vector2.ZERO
			#position += hit.shape.size / 2.0
			z_index = hit.get_parent().z_index - 1
			AnimatorHelper._playanimTreeOneShot(animTree,"Fly",AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
			hit.add_child(self)
			_fadeout(2.0)
			return
		
	
	AnimatorHelper._playanimTreeOneShot(animTree,"Hit",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	AnimatorHelper._playanimTreeOneShot(animTree,"Fly",AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	_fadeout()
	
