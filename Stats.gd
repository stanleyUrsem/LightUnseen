class_name Stats

var health 
var mana  
var defense 
var stamina 

var health_max
var mana_max
var defense_max
var stamina_max

func _init(stats :StatsResource):
	health = stats.health
	mana = stats.mana
	defense = stats.defense
	stamina = stats.stamina
	
func _set_max():
	mana_max = mana
	health_max = health
	defense_max = defense
	stamina_max = stamina
