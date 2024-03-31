extends Passive

class_name ManaAutoHeal

var delay
var heal
var current_heal : float
var healPercentage
var movement : CharacterMovement
var manaHealfx : ManaHealEffect
var current_delay
var tween
func setup_vars(p_movement,p_manaHealFx):
	delay = data.delay
	heal = data.mana_increase
	healPercentage = data.mana_increase_percentage
	current_heal = data.mana_increase
	movement = p_movement
	manaHealfx = p_manaHealFx
	current_delay = delay
	manaHealfx.set_mana_heal(0.0) 
	_setup(func():
		var low_mana = holder.stats.mana < holder.stats.mana_max 
		
		return low_mana
		)

func reset_fx(t):
	if(tween != null):
		tween.kill()
	
	tween = movement.get_tree().create_tween()
	tween.tween_method(manaHealfx.set_mana_heal,t,0.0,0.5)
	current_heal = data.mana_increase
	
func _use(delta):
	current_delay -= delta
	if(current_delay <= 0.0):
		print("CurrentHeal:%f" % current_heal)
		
		if(tween != null):
			tween.kill()
		
		var t = remap(current_heal,holder.stats.mana_max/12.0,0.0,1.0,0.0)
		print("t: %f" % t)
		manaHealfx.set_mana_heal(t)
		var no_movement = movement.velocity.length() == 0
		current_delay = delay if no_movement else delay * 2.0
		current_heal += heal * (1.0+healPercentage)
		var added_mana = holder.add_mana(current_heal)
		if(!added_mana):
			reset_fx(t)
