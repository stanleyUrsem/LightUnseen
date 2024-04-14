extends "res://Character/SionMobArtSetter.gd"

@export var modulate_in : Color
@export var modulate_out : Color

func set_body_part_color(part):
	part.modulate = modulate_out if has_killed else modulate_in
