extends Sprite2D

@export var sprite : Sprite2D

func _ready():
	sprite.frame_changed.connect(set_anim_frame)

func set_anim_frame():
	frame = sprite.frame
