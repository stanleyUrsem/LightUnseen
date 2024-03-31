extends AIState

class_name RiseState

var playerCast : ShapeCast2D
var risen : bool
func setup_vars(p_playerCast):
	risen = false
	playerCast = p_playerCast

func _pre_setup():
	setup(player_near_or_hit,rise,2)

func player_near_or_hit():
	if(ai.player != null):
		return true
	if(playerCast.is_colliding()):
		var count = playerCast.get_collision_count()
		for i in range(count):
			ai.player = playerCast.get_collider(i)
	
func rise():
	if(risen):
		return
	anims.rise()
	risen = true
