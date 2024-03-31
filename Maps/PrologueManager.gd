extends Node


@export var animTree : AnimationTree
#@export var anim_one_shots : Array[String]
#var current_one_shot

func _ready():
	#AnimatorHelper._playanimTreeOneShot(animTree,"Pan",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	AnimatorHelper._playanimTreeBlend2D(animTree,"Pan",1.0)
