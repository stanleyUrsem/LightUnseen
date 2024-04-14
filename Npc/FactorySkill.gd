extends "res://MovableSkill.gd"
@export var part_template : PackedScene
@export var part_pos : Marker2D
@export var part_dir : Marker2D
@export var anim : AnimationPlayer

func _on_setup():
	super()
	anim.play("Throw")

func create_part():
	var part = part_template.instantiate()
	var dir = (part_dir.position - part_pos.position).normalized()
	var main = get_tree().root.get_child(0)
	main.add_child(part)
	part._setup(part_pos.global_position,user,dir,prng)
	part._setup_vars(speed,damage)
	
