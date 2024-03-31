extends AIState


class_name PickUpState

var search_state
#var point : Vector3
var min_dist : float
var meta_pickup
var lowInv

var pickupTween

var collision : Object:
	get:
		return search_state.foodCollision
var point: Vector2:
	get:
		return search_state.point
	set(value):
		search_state.foodPoint.x = value.x
		search_state.foodPoint.y = value.y

var foodPoint: Vector3:
	get:
		return search_state.foodPoint
	set(value):
		search_state.foodPoint = value

func _pre_setup():
	setup(func():
		return (ai.mobMovement.global_position.distance_to(point) < min_dist),
		pickUp,1)
	loop = false

func setup_vars(p_search_state, p_min_dist, p_meta_pickup, p_lowInv):
	search_state = p_search_state
	min_dist = p_min_dist
	meta_pickup = p_meta_pickup
	lowInv = p_lowInv


func _on_enter():
	anims.attack()
	ai.mobMovement.resetMovement()

func pickUp():
	if collision != null:
		var resourceAmount = collision.get_meta(meta_pickup)
		#print("%s %d" % [collision.name, resourceAmount])
		if(resourceAmount == null):
			return
		if(resourceAmount > 0):
			ai.currentState.allowExit = false
			pickupTween = ai.get_tree().create_tween()
			pickupTween.tween_method(set_inv_space,ai.stats.inv_space,
			ai.stats.inv_space-resourceAmount,0.5 * resourceAmount)
			pickupTween.tween_callback(func():
				collision.OnPickUp.emit(collision,
				func():
					foodPoint.z = 0
					ai.currentState.allowExit = true,
					10.0 * resourceAmount))
		else:
			search_state.foodCollision = null
			search_state.foodPoint = Vector3.ZERO

func set_inv_space(x):
	if(ai == null):
		pickupTween.kill()
		return
	if(x > lowInv):
		ai.stats.inv_space = x
	else:
		ai.stats.inv_space = lowInv
	var t = HelperFunctions.remap(ai.stats.inv_space,Vector2(lowInv,ai.stats.inv_space_max),Vector2(0.0,1.0))
	if(ai.sprite.material != null):
		ai.sprite.material.set_shader_parameter("multiplier",lerp(0.0, 0.75,1.0-t))
