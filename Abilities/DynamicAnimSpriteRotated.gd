extends DynamicAnimSprite

@export var rotationHolders : Array[Node2D]
var current_index : int

func _on_setup():
	current_index = 0
	super()
func setup_vars(leftBot, rightTop, p_damage):
	damage = p_damage
	for i in rotationHolders.size():
		current_index = i
		col_parent = rotationHolders[i]
		set_positions(leftBot,rightTop)

func _create_sprite(index,pos):
	var animSprite = create_duplicate_sprite(pos)
	
	animSprite.rotation = 0
	rotationHolders[current_index].add_child(animSprite)
	var collider = animSprite.get_child(0)
	collider.reparent(col_parent)
	sprites.append(animSprite)
