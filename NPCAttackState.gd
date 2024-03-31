extends AttackState

class_name NPCAttackState

func _is_usable():
	var cd_off = super()
	return (cd_off && ai.player != null)
