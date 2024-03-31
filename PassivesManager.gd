extends Node2D

class_name PassivesManager

@export var statsHolder : StatsHolder
@export var movement : CharacterMovement
@export var mana_heal_fx : ManaHealEffect
@export var passive_data : Array[PassiveData]
var passives : Array[Passive]
var conditional_passives : Array[Passive]

func setup():
	create_passives()

func create_passives():
	for data in passive_data:
		if(data.has_condition):
			var mana_heal = create_mana_heal("Mana Heal",data)
			if(mana_heal != null):
				conditional_passives.append(mana_heal)
			continue
		var passive = Passive.new(data,statsHolder)
		passives.append(passive)
		passive._use(0.0)

func create_mana_heal(p_name,data: PassiveData):
	if(data.displayName == p_name):
		var mana_heal = ManaAutoHeal.new(data,statsHolder)
		mana_heal.setup_vars(movement,mana_heal_fx)
		return mana_heal
	return null

func check_passives(delta):
	for passive in conditional_passives:
		passive.check_use(delta)

func _physics_process(delta):
	check_passives(delta)
