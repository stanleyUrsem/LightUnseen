extends "res://MovableSkill.gd"

class_name AnimatableMovableSkill

@export var animTree : AnimationTree


func _on_setup():
	AnimatorHelper._playanimTreeBlend2D(animTree,"Throw",0)

func _ApplyDamage(collision,is_cast=false):
	var hit = super(collision,is_cast)
	AnimatorHelper._playanimTreeBlend2D(animTree,"Throw",1)
	return hit
