extends Control

@export var player_damage : Color
@export var player_heal : Color
@export var mob_damage : Color
@export var duration : float
@export var alpha_curve : Curve
@export var size_curve : Curve
@export var pos_x_curve : Curve
@export var pos_y_curve : Curve
@export var text_label : RichTextLabel

var tween : Tween
var damage : float
var color : Color
var current_color : Color
var saved_pos: Vector2
var offsetX
var offsetY
func _setup(pos,dmg,is_mob,prng : PRNG):
	global_position = pos
	offsetX = prng.range_f(1.0,1.75)
	offsetY = prng.range_f(1.0,1.75)
	if(is_mob):
		color = mob_damage
	else:
		if(dmg < 0):
			color = player_damage
		else:
			color = player_heal
	damage = abs(dmg)
	saved_pos = text_label.position
	tween = get_tree().create_tween()
	tween.tween_method(set_number,0.0,1.0,duration)
	#tween.tween_callback(queue_free)
func set_number(t:float):
	var alpha = alpha_curve.sample(t)
	var text_size = size_curve.sample(t)
	current_color = color
	current_color.a = alpha
	text_label.text = "[color=%s][font_size=%d]%d[/font_size][/color]" % [current_color.to_html(),
	text_size,damage]
	text_label.position.x = saved_pos.x + (pos_x_curve.sample(t)* offsetX)
	text_label.position.y = saved_pos.y + (pos_y_curve.sample(t)* offsetY)
	#if(t >= 1.0):
		#queue_free()
