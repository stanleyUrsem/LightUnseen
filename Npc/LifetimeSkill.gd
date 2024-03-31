extends "res://MovableSkill.gd"

@export var life_time : float
@export var animPlayer : AnimationPlayer
@export var on_expire_anim : String

var expired : bool

func _on_setup():
	expired = false

func _physics_process(delta):
	super(delta)
	life_time -= delta
	if(life_time < 0 && !expired):
		speed = 0.0
		expired = true
		animPlayer.play(on_expire_anim)
