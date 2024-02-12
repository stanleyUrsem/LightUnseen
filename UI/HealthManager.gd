extends FlowContainer

@export var health_bar : PackedScene
@export var barsPerUnit : int
@export var healthPerBar : float
signal on_health_changed(value)
signal on_health_added(value)

var health_bars : Array[TextureProgressBar]

func setup(stats : Stats):
	on_health_added.connect(add_health)
	on_health_changed.connect(update_health)
	var amount = stats.health_max / barsPerUnit

func add_health(value):
	for i in range(value):
		var bar = health_bar.instantiate()
		bar.max_value = healthPerBar
		bar.value = healthPerBar
		bar.tooltip_text = "Health: %d" % (healthPerBar * health_bars.size())
		health_bars.append(bar)
		add_child(bar)
	
func update_health(value):
	var max_hp = healthPerBar * health_bars.size()
	var amount_bars : float = (max_hp - value) / healthPerBar
	for i in health_bars.size():
		#reverse loop
		if(amount_bars <= 0):
			break
			
		var bar = health_bars[-i-1]
		bar.value = 0
		
		if(amount_bars < 1):
			bar.value = amount_bars * healthPerBar
			
			
		amount_bars -= i
	
	for bar in health_bars:
		bar.tooltip_text = "Health: %d" % (healthPerBar * health_bars.size())

	
	
