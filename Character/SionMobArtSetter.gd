extends "res://Character/SionArtSetter.gd"

@export var left_arm : Node2D
@export var right_arm : Node2D
@export var body_hsv_shift_in : Vector3
@export var body_hsv_shift_out : Vector3
func set_body_part_color(part):
	var hsv_shift = hsv_shift_out if has_killed else hsv_shift_in
	part.material.set_shader_parameter("hsv_shift",hsv_shift)

func set_body_color():
	set_body_part_color(body)
	set_body_part_color(left_arm)
	set_body_part_color(right_arm)
