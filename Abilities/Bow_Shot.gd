extends MovableAbilityaction

@export var animTree : AnimationTree

func _ApplyDamage(collision,is_cast=false):
	var hit = super(collision,is_cast)
	#if(hit != null):
	if(!is_cast):
		AnimatorHelper._playanimTreeBlend2D(animTree,"Hit",1.0)
