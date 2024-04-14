extends "res://MovableSkill.gd"

@export var life_time : float
@export var animPlayer : AnimationPlayer
@export var on_expire_anim : String
@export var on_play_anim : String

var expired : bool

func _on_setup():
	expired = false
	animPlayer.play(on_play_anim)
func _ShowHit():
	super()
	expired = true
	animPlayer.play(on_expire_anim)
func _physics_process(delta):
	super(delta)
	life_time -= delta
	if(life_time < 0 && !expired):
		speed = 0.0
		expired = true
		animPlayer.play(on_expire_anim)
