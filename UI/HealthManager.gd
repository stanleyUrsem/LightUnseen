extends Control

class_name HealthManager

@export var health_bar : PackedScene
@export var healthPerBar : float
@export var health_mat : Material
signal on_health_changed(value)
signal on_health_added(value)
var is_setup: bool
var health_bars : Array[TextureProgressBar]
#var currentHp : float = 0
var bars_to_update : Dictionary
var tween : Tween
func setup(stats : Stats):
	if(!is_setup):
		on_health_added.connect(add_health)
		on_health_changed.connect(update_health)
		is_setup = true
	
	#for i in health_bars.size():
		#var bar = health_bars[-i-1]
		#bar.queue_free()
	#
	#health_bars.clear()
	#
	#var amount = stats.health_max / healthPerBar
	add_health(stats.health_max)
	update_health(stats.health)
	
func add_health(value : float):
	
	var amount = ceil(value / healthPerBar)
	
	#var diff = amount - health_bars.size()
	#if(diff < 0): 
		#var to_erase = []
	for i in health_bars.size():
		var bar = health_bars[-i-1]
		bar.queue_free()

	health_bars.clear()
	#currentHp = value
	for i in range(amount):
		var bar = health_bar.instantiate()
		add_child(bar)
		bar.get_child(0).material = health_mat.duplicate(true)
		bar.max_value = healthPerBar
		bar.value = 0.0
		bar.tooltip_text = "Health: %d" % (healthPerBar * health_bars.size())
		health_bars.append(bar)
	update_health(0.0)

func set_bar_value(bar,value):
	if(bar.value - value == 0):
		return
	bars_to_update[bar] = value

func update_health(value):
	
	var max_hp = healthPerBar * health_bars.size()
	#THIS ONLY WORKS ONE WAY
	# NO WAY TO RECOVER
	#100 hp
	#-45 hp
	#55 hp left
	#55 / 20 = 2.75
	#from 5 hp bars to 2.75 
	var hp = value
	var amount_bars : float = hp / healthPerBar
	var amount_bars_floored = floor(amount_bars)
	var hp_empty = false
	
	for i in health_bars.size():
		#reverse loop
		#var bar = health_bars[-i-1]
		var bar = health_bars[i]
		#20 hp
		#hp -= healthPerBar
		#
		if(i > amount_bars_floored - 1):
			var diff = amount_bars-amount_bars_floored
			
			if(diff > 0 && !hp_empty):
				set_bar_value(bar,diff*healthPerBar)
				#bar.value = diff * healthPerBar
				hp_empty = true
				continue
			set_bar_value(bar,0)
			#bar.value = 0
			continue
		set_bar_value(bar,healthPerBar)
		#bar.value = healthPerBar
		#if(hp < 0):
			#hp_empty = true
			#bar.value = hp + healthPerBar
			#continue
			#
		#if(hp_empty || hp == 0):
			#bar.value = 0
			#continue
			
		#bar.value = healthPerBar
		
		#if(amount_bars <= 0):
			#break
			#
		#bar.value = 0
		#
		#if(amount_bars < 1):
			#bar.value = (1-amount_bars) * healthPerBar
			#
			#
		#amount_bars -= i
	#currentHp  += value
	#for bar in health_bars:
		#bar.tooltip_text = "Health: %d" % currentHp
	animate_healthbars()


func animate_healthbars():
	if(tween != null):
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	for key in bars_to_update:
		var current_value = key.value
		var value = bars_to_update[key]
		if(key == null):
			continue
		tween.tween_method(animate_bar_value.bind(key),key.value,value,0.5)
	bars_to_update.clear()

func animate_bar_value(value,bar):
	bar.value = value
