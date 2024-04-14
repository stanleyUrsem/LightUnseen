extends AIState
class_name WanderState
var sightCast
var wanderCast
var staminaUsagePerUnit
var wanderRange
var prng

var isWandering
var currentDist : float
var wanderPoint
var wanderDist
var maxDist : float
var use_saved_pos
func _pre_setup():
	setup(func():
		return (ai.stats.stamina > ai.stats.stamina_max/2.0)
		, wander,1)

func setup_vars(p_sightCast : ShapeCast2D, p_wanderCast : ShapeCast2D,
p_stamina_usage: float, p_wander_range: Vector2, p_prng : PRNG,
p_use_saved_pos = false):
	sightCast = p_sightCast
	wanderCast = p_wanderCast
	staminaUsagePerUnit = p_stamina_usage
	wanderRange = p_wander_range
	prng = p_prng
	use_saved_pos = p_use_saved_pos
		
func to_degrees(radians) -> float:
	return radians * 180.0 / PI;

func get_angle(point, center)-> float:
	var delta = (point - center).normalized()
	var relPoint = delta
	return to_degrees(atan2(relPoint.y, relPoint.x))-90.0

func _on_enter():
	super()
	isWandering = false
func _on_exit():
	super()
	isWandering = false
	
func wander_to(target,speed_multiplier = 1.0, stamina_multiplier = 1.0):
	var pos = ai.mobMovement.global_position
	
	if(!isWandering):
		wanderPoint = target
		sightCast.rotation_degrees = get_angle(wanderPoint, ai.mobMovement.global_position)
		wanderCast.global_position = wanderPoint
		maxDist = pos.distance_to(wanderPoint)
		currentDist = maxDist
		isWandering = !wanderCast.is_colliding()
		if(ai.debug):
			ai.debug_wander_point(wanderPoint)
		if(isWandering):
			ai.mobMovement.moveToPoint(wanderPoint,speed_multiplier)
			anims._walk()
	isWandering = !wanderCast.is_colliding() && !ai.mobMovement.is_on_wall()
	
	currentDist = pos.distance_to(wanderPoint)
	var passed_point = currentDist > maxDist
	if((currentDist < 5.0 || passed_point)  && isWandering):
		isWandering = false
		ai.stats.stamina -= (maxDist * staminaUsagePerUnit * stamina_multiplier)
		called_amount += 1
		ai.mobMovement.resetMovement()
	return isWandering

func wander(speed_multiplier = 1.0, stamina_multiplier = 1.0,use_saved_pos = false):
	
	var pos = ai.saved_pos if use_saved_pos else ai.mobMovement.global_position 
	
	if(!isWandering):
		wanderDist = prng.range_f(wanderRange.x,wanderRange.y)
		var rot = prng.random_unit_circle(true)
		wanderPoint = (rot * wanderDist) + pos
		sightCast.rotation_degrees = get_angle(wanderPoint, ai.mobMovement.global_position)
		wanderCast.global_position = wanderPoint
		maxDist = pos.distance_to(wanderPoint)
		currentDist = maxDist
		isWandering = !wanderCast.is_colliding()
		if(ai.debug):
			ai.debug_wander_point(wanderPoint)
		if(isWandering):
			ai.mobMovement.moveToPoint(wanderPoint,speed_multiplier)
			anims._walk()
	isWandering = !wanderCast.is_colliding() && !ai.mobMovement.is_on_wall()
	
	currentDist = pos.distance_to(wanderPoint)
	var passed_point = currentDist > maxDist		
	if((currentDist < 1.0 || passed_point)  && isWandering):
		isWandering = false
		ai.stats.stamina -= (wanderDist * staminaUsagePerUnit * stamina_multiplier);
		called_amount += 1
		ai.mobMovement.resetMovement()
