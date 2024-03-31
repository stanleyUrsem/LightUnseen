extends AIState

class_name CallBackupState

var healthPercentage : float
var mob_types : Array[Vector2i]
func _pre_setup():
	healthPercentage = 1.0
	setup(
		func():
			var perc = ai.stats.health_max * healthPercentage
			var low_hp = ai.stats.health <= perc
			return low_hp && mob_types.size() > 0,
	call_backup,5)


func setup_vars(p_healthPercentage,p_mob_types):
	healthPercentage = p_healthPercentage
	mob_types = p_mob_types

func call_backup():
	var mob_spawner = ai.get_parent().get_parent() as MobSpawner
	
	for type_amount in mob_types:
		var type = type_amount.x
		for i in range(type_amount.y):
			var mobAI = mob_spawner.respawn_mob(type)
			mobAI.player = ai.player
			
	
	mob_types.clear()
