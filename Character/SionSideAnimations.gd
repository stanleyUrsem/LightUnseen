extends AnimatableCharacter

func _setup(animator,sprite : Sprite2D, timer : Timer):
	super(animator,sprite,timer)
	_sprite.texture = preload("res://Character/Textures/Sion/sheet.png")
	_timer.timeout.connect(_wink)


func _wink():
	_playanimTreeOneShot("IdleToWink",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func _idle():
	_playanimTreeBlend2D("IdleToWalk",0)

func _walk():
	_playanimTreeBlend2D("IdleToWalk",1)

func _turn(turn : float):
	if(_animator == null || turnCurrent == turn):
		return
	if(turn > 0):
		_playanimTreeBlend2D("LeftToRight",0)
		
		_playanimTreeOneShot("TurnLeft",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		_playanimTreeBlend2D("LeftToRight",1)
		_playanimTreeOneShot("TurnRight",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	turnCurrent = turn
		
