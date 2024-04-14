extends DynamicCastedSprite

@export var rotationHolders : Array[Node2D]

func _on_setup():
	#current_index = 0
	super()
#func setup_vars(leftBot, rightTop, p_damage):
	#damage = p_damage
	#for i in rotationHolders.size():
		#current_index = i
		#col_parent = rotationHolders[i]
		#set_positions(leftBot,rightTop)

func _create_sprite(index,pos):
	for rot_holder in rotationHolders:
		var animSprite = create_duplicate_sprite(pos)
		rot_holder.add_child(animSprite)
		animSprite.scale = Vector2.ONE
		animSprite.rotation_degrees = 0
		var collider = animSprite.get_child(0)
		collider.reparent(col_parent)
		var shape_cast = animSprite.get_node("ShapeCast2D")
		#shape_cast.reparent(col_parent)
		#shape_cast.position = pos
		shape_casts.append(shape_cast)
		sprites.append(animSprite)
