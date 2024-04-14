extends StaticBody2D

@export var current_health : float
@export var hittable : Hittable
@export var animTree : AnimationTree
@export var on_hit_anim : AnimationTransition
@export var on_break_anim : AnimationTransition
@export var shield_hit_anim : AnimationTransition



func _ready():
	hittable.OnHit.connect(on_hit)

func on_hit(dmg,user):
	current_health += dmg
	if(current_health <= 0):
		AnimatorHelper._playanimTransition(animTree,on_break_anim)
	else:
		AnimatorHelper._playanimTransition(animTree,on_hit_anim)
	AnimatorHelper._playanimTransition(animTree,shield_hit_anim)
		
#func update_collision(delta):
	#var col = move_and_collide(Vector2.ZERO,true)
	#if(col != null):
		#
