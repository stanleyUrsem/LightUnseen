extends Node

class_name Passive

var condition : Callable
var data : PassiveData
var holder : StatsHolder

func _init(p_data : PassiveData,p_holder : StatsHolder):
	data = p_data
	holder = p_holder
	
func _setup(p_condition = null):
	condition = p_condition

func check_use(delta):
	if(condition == null):
		return
	
	var allowed = condition.call()
	if(allowed):
		_use(delta)
	
func _use(delta):
	holder.add_mana(data.mana_increase,true)
	holder.add_mana(holder.stats.mana_max * (data.mana_increase_percentage/100.0),true)
	
	holder.stats.defense_max += data.defense_increase
	holder.stats.defense_max += holder.stats.defense_max * data.defense_increase_percentage
	
	holder.add_health(data.health_increase,true)
	holder.add_health(holder.stats.health_max * (data.health_increase_percentage/100.0),true)
	
