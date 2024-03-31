extends "res://Abilities/DynamicAnimSpriteRotated.gd"
@export var animPlayer : AnimationPlayer
var leftBot
var rightTop
var collider_dict
func play_sprites(anim_name : String, index : int):
	for i in rotationHolders[index].get_child_count():
		var sprite = rotationHolders[index].get_child(i)
		sprite.play(anim_name)
	#for sprite in sprites:
		#sprite.play(anim_name)
func play_all_sprites(anim_name : String):
	for sprite in sprites:
		sprite.play(anim_name)
func create_sprites(from_index : int, to_index:int):
	var range_index = to_index-from_index
	
	for i in rotationHolders.size():
		if(i < from_index || i > to_index):
			continue
		col_parent = rotationHolders[i]
		set_positions(leftBot,rightTop)
func enable_colliders(index: int):
	for i in rotationHolders[index].get_child_count():
		var sprite = rotationHolders[index].get_child(i)
		var collider = sprite.get_child(0)
		collider.scale = Vector2.ONE
func disable_colliders():
	for sprite in sprites:
		var collider = sprite.get_child(0)
		collider.scale = Vector2.ZERO
func _on_setup():
	current_index = 0
	
func setup_vars(p_leftBot, p_rightTop, p_damage):
	damage = p_damage
	leftBot = p_leftBot
	rightTop = p_rightTop
	animPlayer.play("Charge_Volley_1")
	#for i in rotationHolders.size():
		#current_index = i
		#col_parent = rotationHolders[i]
		#set_positions(leftBot,rightTop)

func _create_sprite(index,pos):
	var animSprite = create_duplicate_sprite(pos)
	var collider = animSprite.get_child(0)
	collider.reparent(col_parent)
	collider.scale = Vector2.ZERO
	animSprite.rotation = 0
	rotationHolders[index].add_child(animSprite)
	sprites.append(animSprite)
	
	if(collider_dict.has(index)):
		collider_dict[index].append(collider)
	else:
		var cols
		collider_dict[index] = cols.append(collider)
