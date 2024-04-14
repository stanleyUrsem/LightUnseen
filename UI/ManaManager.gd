extends ProgressBar
class_name ManaManager

@export var text_rect : ColorRect
var tween
var called : int
var initial_old : float
var mana : float :
	get: 
		return value
	set(p_value): 
		animate_manabars(value,p_value)

func setup(stats: Stats):
	max_value = stats.mana_max
	value = 0.0
	called = 0
	mana = max_value
func _bar_anim_complete():
	called = 0

func animate_manabars(p_old, p_new):
	#if(called > 0):
		#return
	#called += 1
	if(tween != null):
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_method(animate_bar_value,value,p_new,0.5)
	tween.tween_callback(_bar_anim_complete)

func animate_bar_value(p_value):
	#print_stack()
	value = p_value
	var alpha = value/max_value
	var fill_value =  text_rect.material.get_shader_parameter("fill_value_x")
	#print(fill_value)
	text_rect.material.set_shader_parameter("fill_value_x",alpha)
	
