extends Sprite2D

@export var anim : AnimationPlayer

func setup(prng:PRNG):
	var index = prng.range_i_mn(1,4)
	anim.speed_scale = prng.range_f(0.75,1.0)
	play_anim(index)
	
func play_anim(index):
	var str = "new_animation_%s"
	anim.play(str % index)
