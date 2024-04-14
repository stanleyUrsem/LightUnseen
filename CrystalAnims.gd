extends AnimatableCharacter

class_name CrystalAnims

func _idle():
	AnimatorHelper._playanimTreeBlend2D(_animator,"Walk",0)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Death", 0)
	
func still():
	AnimatorHelper._playanimTreeBlend2D(_animator,"Spawned", 0)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Death", 0)
	
	
func _walk():
	AnimatorHelper._playanimTreeBlend2D(_animator,"Spawned", 1)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Walk",1)
	AnimatorHelper._playanimTreeBlend2D(_animator,"Death", 0)

func rise():
	AnimatorHelper._playanimTreeOneShotFire(_animator,"Spawn")
	

