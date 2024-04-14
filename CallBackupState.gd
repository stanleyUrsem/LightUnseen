extends AIState

class_name CallBackupState

var healthPercentage : float
var amount : int
func _pre_setup():
	healthPercentage = 1.0
	setup(
		func():
			var perc = ai.stats.health_max * healthPercentage
			var low_hp = ai.stats.health <= perc
			return low_hp,
	call_backup,5)


func setup_vars(p_healthPercentage,p_amount):
	healthPercentage = p_healthPercentage
	amount = p_amount

func call_backup():
	var mob_spawner = ai.get_parent().get_parent() as MobSpawner
	
	for i in range(amount):
		var index = ai.prng.range_i_mn(0,mob_spawner.get_child_count()-1)
		var mob = mob_spawner.get_child(index)
		var mob_ai = mob.get_node("AI")
		mob_ai.player = ai.player
		#var type = type_amount.x
		#for i in range(type_amount.y):
			#var mobAI = mob_spawner.respawn_mob(type)
			#mobAI.player = ai.player
			
	
