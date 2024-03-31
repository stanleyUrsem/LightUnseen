class_name AnimatorHelper

static func _playanimTransition(animator,transition:AnimationTransition):
	_playanimType(transition.animType,animator,transition.animName,
	transition.blend_add_value,transition.one_shot)

static func _playanimType(animType,animator,name,value,one_shot):
	match(animType):
		AbilityData.AnimationNodeType.ONESHOT:
			_playanimTreeOneShot(animator,name,one_shot)
		AbilityData.AnimationNodeType.ADD:
			_playanimTreeAdd2D(animator,name,value)
		AbilityData.AnimationNodeType.BLEND:
			_playanimTreeBlend2D(animator,name,value)
	
static func _playanimTreeOneShot(animator,name, value : AnimationNodeOneShot.OneShotRequest):
	if(animator == null):
		return
	animator.set("parameters/"+name+"/request",value)
static func _playanimTreeOneShotFire(animator,name):
	if(animator == null):
		return
	_playanimTreeOneShot(animator,name,
	AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

static func _playanimTreeOneShotAbort(animator,name):
	if(animator == null):
		return
	_playanimTreeOneShot(animator,name,
	AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	
static func _playanimTreeAdd2D(animator,name, value : float):
	if(animator == null):
		return
	animator.set("parameters/"+name+"/add_amount",value)
static func _playanimTreeBlend2D(animator,name, value : float):
	if(animator == null):
		return
	animator.set("parameters/"+name+"/blend_amount",value)
	
static func _setSpeedScale(animator,name, value : float):
	if(animator == null):
		return
	animator.set("parameters/"+name+"/scale",value)
	
static func _playanim(animator,name):
	
	if(animator == null):
		return
		
#	_animator.set("parameters/")
		
	if name != animator.get_animation().resource_name:
		animator.stop(true)
	animator.play(name)
