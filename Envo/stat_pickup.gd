extends "res://Pickup.gd"

@export var add_stat : float

func add_consumable(body):
	var stats = body.get_node("Stats")
	match(type):
		Consume.consumable.HP:
			stats.add_health(add_stat,true)
		Consume.consumable.MANA:
			stats.add_mana(add_stat,true)
			
