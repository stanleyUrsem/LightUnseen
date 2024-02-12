extends Stats

class_name SlimeStats

@export var inv_space = 1

var inv_space_max

func _init(stats : SlimeStatsResource):
	super(stats)
	inv_space = stats.inv_space

func _set_max():
	super()
	inv_space_max = inv_space
	
