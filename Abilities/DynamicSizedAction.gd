extends SkillAction

@export var offset : Vector2
var amount_sprites : int
func setup_vars(leftBot, rightTop, p_damage, p_rotation_degrees):
	damage = p_damage
	rotation_degrees = p_rotation_degrees
	#var height = abs(abs(leftBot.position.y) - abs(rightTop.position.y))
	set_positions(leftBot,rightTop)
	
func set_positions(leftBot,rightTop):
	var length = abs(abs(leftBot.position.x) - abs(rightTop.position.x))
	#shapeCast.scale.x = length
	#shapeCast.position.x = (length / 2.0) 
	amount_sprites = floor(length / offset.x)
	if(offset.x == 0 && abs(offset.y) > 0):
		length = abs(abs(leftBot.position.y) - abs(rightTop.position.y))
		amount_sprites = floor(length / abs(offset.y))
		
	print("Amount sprites: %d\nLength %f" % [amount_sprites,length])
	for i in amount_sprites:
		var pos = float(i) * offset / scale
		_create_sprite(i,pos)
	#_create_collider(length)
	
#func _create_collider(length):
	#pass
func _create_sprite(index,pos):
	pass
