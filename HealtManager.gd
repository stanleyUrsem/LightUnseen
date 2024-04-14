extends ManaManager

var health : float :
	get: 
		return value
	set(p_value): 
		animate_manabars(value,p_value)

func setup(stats: Stats):
	max_value = stats.health_max
	value = 0.0
	health = max_value
