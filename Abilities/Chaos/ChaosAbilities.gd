extends Node

@export var abilities : Array[Ability]

var amount_abilities : int

func _ready():
	var ability = preload("res://Abilities/Ability.tscn")
	setupAbilities(ability)


func setupAbilities(ability : PackedScene):
	var a = ability.instantiate() as Ability
	a.setup(func() -> bool: return true)
	
	add_child(a)
	abilities.append(a)
	
func _physics_process(delta):
	for i in abilities.size():
		if(abilities[i].isSetup):
			print(abilities[i].canObtain())
