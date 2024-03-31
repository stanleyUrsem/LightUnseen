extends ProgressBar
class_name ManaManager

@export var text_rect : ColorRect
var tween

var mana : float :
	get: 
		return value
	set(p_value): 
		animate_manabars(value,p_value)

func setup(stats: Stats):
	max_value = stats.mana_max
	value = 0.0
	mana = max_value

	

func animate_manabars(p_old, p_new):
	if(tween != null):
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_method(animate_bar_value,p_old,p_new,0.5)

func animate_bar_value(p_value):
	value = p_value
	text_rect.material.set_shader_parameter("fVx",p_value/max_value)
	
