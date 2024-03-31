extends Node

class_name Hittable
@export_enum("VISCIOUS","SOLID") var type : int
signal OnHit(hit, user)


	#if(changeDuration > 0):
		#var changeTween = create_tween()
		#changeTween.tween_interval(changeDuration)
		#changeTween.tween_callback(func(): ai.stats.health = currentStat)
