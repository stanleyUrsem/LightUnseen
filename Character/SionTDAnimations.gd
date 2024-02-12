extends AnimatableCharacter

class_name SionTDAnimations


#func _setup_texture():
#	_sprite.texture = preload("res://Character/Textures/SionTD/sion.png")	

func _idle():
	AnimatorHelper._playanimTreeBlend2D(_animator,"IdleToWalk",0)

func _walk():
	AnimatorHelper._playanimTreeBlend2D(_animator,"IdleToWalk",1)

func _roll():
	AnimatorHelper._playanimTreeOneShot(_animator,"UseRoll",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _attack():
	AnimatorHelper._playanimTreeOneShot(_animator,"UseAttack",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func _dodge():
	AnimatorHelper._playanimTreeOneShot(_animator,"UseDodge",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _lrattack():
	AnimatorHelper._playanimTreeOneShot(_animator,"UseLRAttack",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	


		
