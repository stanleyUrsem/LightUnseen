class_name AnimatableCharacter

extends Node
var _animator
var turnCurrent
func _setup(animator):
	_animator = animator
	turnCurrent = 0
	_setup_texture() 

func _setup_texture():
	pass
func _idle():
	pass

func _walk():
	pass

func _turn(turn : float):
	if(_animator == null || turnCurrent == turn):
		return
	if(turn > 0):
		AnimatorHelper._playanimTreeBlend2D(_animator,"LeftOrRight",0)
	else:
		AnimatorHelper._playanimTreeBlend2D(_animator,"LeftOrRight",1)
	turnCurrent = turn

func alive():
	AnimatorHelper._playanimTreeBlend2D(_animator,"Death",0.0)
			
func death():
	AnimatorHelper._playanimTreeOneShotFire(_animator,"OnDeath")


