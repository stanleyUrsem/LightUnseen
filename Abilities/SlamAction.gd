extends DynamicAbilityAction
##
@export var sprites : Array[AnimatedSprite2D]

func create_duplicate_sprite(pos):
	var sprite = super(pos)
	sprites.append(sprite)
	return sprite
func set_positions(leftBot,rightTop):
	super(leftBot,rightTop)
	sprites[0].animation_finished.connect(_fadeout)
	for sprite in sprites:
		sprite.play("dust")
func _create_sprite(index,pos):
	#if(index <= 2): 
		#return
	var animSprite = create_duplicate_sprite(pos)
	add_child(animSprite)
	var collider = animSprite.get_child(0)
	collider.reparent(body)
	collider.position = pos
