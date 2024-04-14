extends WanderState

class_name WanderToPlayerState

func _pre_setup():
	setup(allow_wander,func():
		wander_to(ai.player.global_position)
		,2)

func allow_wander():
	return player_found() && enough_stamina()

func player_found():
	return ai.player != null
func enough_stamina():
	return (ai.stats.stamina > ai.stats.stamina_max/2.0)
