extends AIState

class_name Idle_State

var staminaTimer
var recovery_duration

func _pre_setup():
	setup(func():
		return ai.stats.stamina <= ai.stats.stamina_max/2.0
		, idle,5)

func setup_vars(p_staminaTimer: Timer, p_recovery_duration):
	staminaTimer = p_staminaTimer
	recovery_duration = p_recovery_duration
	
func _on_enter():
	anims._idle()
	
func _on_exit():
	reset_idle_state()

func idle():
	ai.mobMovement.stopMovement()
	ai.staminaTimer.start(recovery_duration)
		
func reset_idle_state():
	ai.staminaRecovered = 0
	ai.staminaTimer.stop()
