extends "res://Abilities/DynamicAnimSpriteRotated.gd"
@export var end_frame : String
var end_sprites : Array
var end_sprite : bool
var begin_frame : String
##
func _on_setup():
	super()
	#begin_frame = animation_name
func set_positions(leftBot,rightTop):
	super(leftBot,rightTop)
	for sprite in end_sprites:
		sprite.animation = end_frame
	play_anim_sprite("")
#func play_next(index):
	#if(index >= sprites.size()):
		#super(index)
		#return
	#if(end_sprites.has(sprites[index])):
		#animation_name = end_frame
	#else:
		#animation_name = begin_frame
	#super(index)
	#sprites[index].play(animation_name)
	
			
func create_duplicate_sprite(pos):
	var sprite = super(pos)
	if(end_sprite):
		end_sprites.append(sprite)
	return sprite

func _create_sprite(index,pos):
	end_sprite = index >= amount_sprites -1
	#print("Chainsaw index: %d %s" % [index,end_sprite])
	super(index,pos)
	#if(index >= amount_sprites - 1 ):
		#sprites[index].animation = end_frame
