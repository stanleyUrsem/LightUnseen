extends AbilityAction
@export var sprites : Array[AnimatedSprite2D]


func _on_setup():
	sprites[0].animation_finished.connect(_fadeout)
	for sprite in sprites:
		sprite.play("dust")

func _OnHit(collision):
	super(collision)
	_ApplyDamage(collision)
