extends Area2D
@export var entrance : bool
@export var mapData : MapData
var mobSpawner : MobSpawner
func _ready():
	mobSpawner = get_node("/root/MAIN/MobSpawner")
	#mapData = get_node(".")
	body_entered.connect(on_enter)
	body_exited.connect(on_exit)

func on_enter(body):
	if(entrance):
		#for type_amount in mapData.mob_type_chance:
			#var type = type_amount.x
			#var amount = type_amount.y
		mobSpawner.set_active_map(mapData)

func on_exit(body):
	if(!entrance):
		mobSpawner.clear_mobs()
