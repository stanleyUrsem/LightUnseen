extends Resource

class_name StatsResource


@export var health = 1.0
@export var mana  = 1.0
@export var defense = 1.0
@export var stamina = 1.0

var health_max
var mana_max
var defense_max
var stamina_max


func _init(p_health= null, p_mana=null, p_defense=null, p_stamina=null):
	health = p_health
	mana = p_mana
	defense = p_defense
	stamina = p_stamina


	
