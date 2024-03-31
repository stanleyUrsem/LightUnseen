extends AnimationPlayer

@export var anim : String

func _ready():
	play(anim)
