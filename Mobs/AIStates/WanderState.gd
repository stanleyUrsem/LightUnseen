extends AIState
class_name WanderState
var sightCast
var wanderCast
var staminaUsagePerUnit
var wanderRange
var prng

var isWandering
var currentDist
var wanderPoint
var wanderDist

func _pre_setup():
	setup(func():
		return (ai.stats.stamina > ai.stats.stamina_max/2.0)
		, wander,1)

func setup_vars(p_sightCast : ShapeCast2D, p_wanderCast : ShapeCast2D,
p_stamina_usage: float, p_wander_range: Vector2, p_prng : PRNG):
	sightCast = p_sightCast
	wanderCast = p_wanderCast
	staminaUsagePerUnit = p_stamina_usage
	wanderRange = p_wander_range
	prng = p_prng
		
func to_degrees(radians) -> float:
	return radians * 180.0 / PI;

func get_angle(point, center)-> float:
	var delta = (point - center).normalized()
	var relPoint = delta
	return to_degrees(atan2(relPoint.y, relPoint.x))-90.0


func wander(speed_multiplier = 1.0, stamina_multiplier = 1.0):
	
	var pos = ai.mobMovement.global_position
	var maxDist = 1.0
	
	if(!isWandering):
		wanderDist = prng.range_f(wanderRange.x,wanderRange.y)
		var rot = prng.random_unit_circle(true)
		wanderPoint = (rot * wanderDist) + pos
		sightCast.rotation_degrees = get_angle(wanderPoint, ai.mobMovement.global_position)
		wanderCast.global_position = wanderPoint
		maxDist = pos.distance_to(wanderPoint)
		if(isWandering):
			anims._walk()
	isWandering = !wanderCast.is_colliding()
	
	currentDist = pos.distance_to(wanderPoint)
	if(currentDist < 1.0  && isWandering):
		isWandering = false
		ai.stats.stamina -= (wanderDist * staminaUsagePerUnit * stamina_multiplier);

		ai.mobMovement.stopMovement()
	ai.mobMovement.moveToPoint(wanderPoint,speed_multiplier, currentDist > 20.0)
