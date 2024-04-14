extends "res://Npc/DynamicSprite.gd"

class_name DynamicCastedSprite

var shape_casts : Array[ShapeCast2D]
@export var refresh_collision_cooldown : float
var refresh_cd : float
func _create_sprite(index,pos):
	super(index,pos)
	var animSprite = sprites[sprites.size()-1] 
	var shape_cast = animSprite.get_node("ShapeCast2D")
	shape_cast.reparent(col_parent)
	shape_cast.position = pos
	shape_casts.append(shape_cast)

func _physics_process(delta):
	super(delta)
	check_cast_collisions()
	if(refresh_cd > 0.0):
		refresh_cd -= delta
	
	if(refresh_cd <= 0.0):
		refresh_cd = refresh_collision_cooldown
		cols_hit.clear()
func check_cast_collisions():
	for cast in	shape_casts:
		shapeCast = cast
		check_collision()
