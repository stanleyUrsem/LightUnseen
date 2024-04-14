extends "res://MovableSkill.gd"

@export var proximity_area : Area2D
@export var animTree : AnimationTree

func _on_setup():
	AnimatorHelper._playanimTreeBlend2D(animTree,"Throw",0) 
	
func on_body_enter(body):
	speed = 0
	AnimatorHelper._playanimTreeBlend2D(animTree,"Throw",1) 
	
	

