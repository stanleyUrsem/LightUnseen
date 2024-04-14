extends Node2D

var deathTransition : DeathTransition

func _ready():
	deathTransition = get_node("/root/MAIN/DeathTransition")
	
func game_complete():
	deathTransition.on_complete()
