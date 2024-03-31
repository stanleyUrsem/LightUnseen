extends SkillAction

@export var offset : Vector2
var amount_sprites : int
func setup_vars(leftBot, rightTop, p_damage):
	damage = p_damage
	#var height = abs(abs(leftBot.position.y) - abs(rightTop.position.y))
	set_positions(leftBot,rightTop)
	
func set_positions(leftBot,rightTop):
	var length = abs(abs(leftBot.position.x) - abs(rightTop.position.x))
	#shapeCast.scale.x = length
	#shapeCast.position.x = (length / 2.0) 
	amount_sprites = floor(length / offset)
	
	for i in amount_sprites:
		_create_sprite(i,float(i) * offset)
	#_create_collider(length)
	
#func _create_collider(length):
	#pass
func _create_sprite(index,pos):
	pass
