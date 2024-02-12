class_name AnimatorHelper


static func _playanimTreeOneShot(animator,name, value : AnimationNodeOneShot.OneShotRequest):
	if(animator == null):
		return
	animator.set("parameters/"+name+"/request",value)
	
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
