extends AIState

class_name Idle_State

var recovery_duration
var staminaRecovered
var staminaRecoveryMinimum
var staminaRecoveryRange
var tween : Tween
var isRecovering : bool
func _pre_setup():
	setup(func():
		return ai.stats.stamina <= ai.stats.stamina_max/2.0
		, idle,5)

func setup_vars(p_recovery_duration,p_staminaRecoveryMin, p_staminaRecovery):
	recovery_duration = p_recovery_duration
	staminaRecoveryRange = p_staminaRecovery
	staminaRecoveryMinimum = p_staminaRecoveryMin
	isRecovering = false
	staminaRecovered = 0
	#ai.staminaTimer.timeout.connect(recover_stamina)
	
func _on_enter():
	anims._idle()
	
func _on_exit():
	super()
	reset_idle_state()

func idle():
	ai.mobMovement.resetMovement()
	if(isRecovering):
		return
	isRecovering = true
	if(tween != null):
		tween.kill()
	tween = ai.get_tree().create_tween()
	tween.set_loops(-1)
	tween.tween_interval(1.0)
	tween.tween_callback(recover_stamina)
	#ai.staminaTimer.start(recovery_duration)
		
func reset_idle_state():
	staminaRecovered = 0
	isRecovering = false
	#ai.staminaTimer.stop()
	if(tween != null):
		tween.kill()
	
func recover_stamina():
	if(ai == null):
		tween.kill()
		return
	allowExit = staminaRecovered > staminaRecoveryMinimum
	if(ai.stats.stamina < ai.stats.stamina_max):
		var recovery = ai.prng.range_f(staminaRecoveryRange.x,staminaRecoveryRange.y)
		recovery = (1.0/recovery) * ai.stats.stamina_max
		ai.stats.stamina += recovery
		staminaRecovered += recovery
		print("Recovering stamina: ", ai.stats.stamina)
		called_amount += 1
