extends "res://MovableSkill.gd"
@export var part_template : PackedScene
@export var part_pos : Marker2D
@export var part_dir : Marker2D

func create_part():
	var part = part_template.instantiate()
	var dir = part_dir.position - part_pos.position
	part.setup_vars(speed,dir)
	add_sibling(part)
	
