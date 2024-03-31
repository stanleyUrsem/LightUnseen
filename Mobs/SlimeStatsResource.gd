extends StatsResource

class_name SlimeStatsResource

@export var inv_space = 1
var inv_space_max

func _init(p_health = null,p_mana = null,p_defense = null,p_stamina = null,p_inv_space = null):
	super(p_health,p_mana,p_defense,p_stamina)
	inv_space = p_inv_space

