extends AIState

class_name CircleAroundState
var radius
var minDist
var wanderCast
var isCircling : bool
var angle_range
var prng
var staminaUsagePerUnit
var currentDist = 0.0
var distPlayer = 0.0
var angle_point
var angle_dist

var player: Node2D: 
	get: 
		return ai.player

func _pre_setup():
	var movement = ai.mobMovement

	
	setup(func():
		if(player == null):
			return false
		distPlayer = movement.global_position.distance_to(player.global_position)
		return distPlayer <= minDist,
		func(): circle_around_point(player.global_position),3)
func setup_vars(p_radius,p_angle_range, p_wanderCast, p_prng,
 p_staminaUsage,p_minDist):
	radius = p_radius
	angle_range = p_angle_range
	prng = p_prng
	staminaUsagePerUnit = p_staminaUsage
	wanderCast = p_wanderCast
	minDist = p_minDist
	currentDist = 0.0
	
func get_angle_position(point,angle_offset):
	#define a radius
	#get current position
	var pos = ai.mobMovement.global_position
	#get point position
	#normalize the direction between
	#var dir = (pos - point).normalized()
	#get the current angle of current position relative to point
	var current_angle = HelperFunctions.get_angle(pos,point) + angle_offset
	#add or subtract from the angle to go to next position
	return point + HelperFunctions.get_point_from_angle(current_angle,radius)
func _on_exit():
	super()
	isCircling = false
func circle_around_point(point,speed_multiplier = 1.0, stamina_multiplier = 1.0):
	#circle around a point
		
	var pos = ai.mobMovement.global_position
	var maxDist = 1.0
	
	if(!isCircling):
		var angle_offset = prng.range_f(angle_range.x,angle_range.y)
		angle_dist = angle_offset
		angle_point = get_angle_position(point,angle_offset)
		wanderCast.global_position = angle_point
		var dist = angle_point.distance_to(player.global_position) <= minDist
		isCircling = !wanderCast.is_colliding() && dist
		if(isCircling):
			anims._walk()
	
	isCircling = !wanderCast.is_colliding() && !ai.mobMovement.is_on_wall()
	var passed_point = currentDist > maxDist		
	currentDist = pos.distance_to(angle_point)
	if((currentDist < 1.0 || passed_point)  && isCircling):
		isCircling = false
		ai.stats.stamina -= (angle_dist * staminaUsagePerUnit * stamina_multiplier);
		ai.mobMovement.resetMovement()
		
	ai.mobMovement.moveToPoint(angle_point,speed_multiplier)
