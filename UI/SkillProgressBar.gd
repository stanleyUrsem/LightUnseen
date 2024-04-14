extends ManaManager
@export var root : Control
signal OnBarComplete(bar)
var progress : float:
	get:
		return value
	set(p_value):
		animate_manabars(value,p_value)

func fade_in():
	if(root.visible):
		return
	root.visible = true
	if(tween != null):
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_method(fade,0.0,1.0,0.5)
		
func animate_manabars(p_old, p_new):
	if(tween != null):
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_method(animate_bar_value,p_old,p_new,0.5)
	tween.tween_method(fade,1.0,0.0,1.5)
	tween.tween_callback(_bar_anim_complete)
	
func fade(x):
	root.modulate.a = x
#func setup_progress(alpha):
	#max_value = 100.0
	#value = alpha
	##animate_bar_value(0.0)
	##visible = true

func _bar_anim_complete():
	root.visible = false

