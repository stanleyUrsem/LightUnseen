extends AbilityAction

class_name DynamicAbilityAction

@export var animSpriteTemplate : PackedScene
@export var offset : Vector2
var amount_sprites : int
func setup_dynamic(leftBot, rightTop, p_damage, p_rotation_degrees):
	damage = p_damage
		
	rotation_degrees = p_rotation_degrees
	var parent = leftBot.get_parent()
	if(parent.scale.x < 0):
		rotation_degrees -= 180
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
	
#func _create_collider(length):
	#pass
func create_duplicate_sprite(pos):
	var animSprite = animSpriteTemplate.instantiate()
	if(animSprite is mine_field_ground):
		animSprite.setup(data,mouseHandler,user,prng)
	animSprite.position = pos
	#animSprite.global_position = pos - global_position
	return animSprite


func _create_sprite(index,pos):
	#if(index <= 2): 
		#return
	var animSprite = create_duplicate_sprite(pos)
	#var main = get_tree().root.get_child(0)
	#main.add_child(animSprite)
	add_child(animSprite)
