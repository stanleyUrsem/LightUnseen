extends AnimatableCharacter

class_name SlimeAnimations


func _idle():
	AnimatorHelper._playanimTreeBlend2D(_animator,"StillToIdle",1)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Attack", 0)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Walk",0)
	
func _still():
	AnimatorHelper._playanimTreeBlend2D(_animator,"StillToIdle",0)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Attack", 0)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Walk",0)
	
	
func _walk():
	AnimatorHelper._playanimTreeBlend2D(_animator,"StillToIdle",0)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Attack", 0)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Walk",1)
	
func attack():
	AnimatorHelper._playanimTreeBlend2D(_animator,"Attack",1)
	AnimatorHelper._playanimTreeBlend2D(_animator,"StillToIdle",0)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Walk",0)
