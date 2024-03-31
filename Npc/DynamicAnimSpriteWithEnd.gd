extends "res://Abilities/DynamicAnimSpriteRotated.gd"
@export var end_frame : String


func _create_sprite(index,pos):
	super(index,pos)
	if(index >= amount_sprites - 1 ):
		sprites[index].animation = end_frame
