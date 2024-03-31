extends CPUParticles2D


class_name ManaHealEffect

@export var alpha_curve : Curve
@export var radial_range : Vector2
@export var change_curve : Curve
@export var gravityY_range : Vector2
@export var velo_max_range : Vector2
@export var rect_ext_range : Vector2





func set_mana_heal(t):
	t = change_curve.sample(clamp(t,0.0,1.0))
	#print("mana Heal: %f" % t)
	color.a = alpha_curve.sample(t)
	#amount = lerp(emit_range.x,emit_range.y,t)
	emission_rect_extents.x = lerp(rect_ext_range.x,rect_ext_range.y,t)
	radial_accel_max = lerp(radial_range.x,radial_range.y,t)
	gravity.y = lerp(gravityY_range.x,gravityY_range.y,t)
	initial_velocity_max = lerp(velo_max_range.x,velo_max_range.y,t)
	

