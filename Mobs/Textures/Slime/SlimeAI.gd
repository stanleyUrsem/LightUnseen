extends AI

class_name SlimeAI

@export var mobMovement : MobMovement
@export var wanderCast : ShapeCast2D
@export var lowInv : int = 1
@export var wanderRange : Vector2
@export var staminaRecovery : Vector2
@export var staminaUsagePerUnit = 1.0

@export var staminaRecoveryDuration = 1
@export var staminaRecoveryMinimum = 20
@export var distanceMax = 1
@export var staminaTimer : Timer
@export var food_min_dist: float
@export var sightCast : ShapeCast2D
@export var stats_resource : SlimeStatsResource
@export var sprite: Sprite2D
#What would a mob do first.

#on their own:
## Walk to random points, is weak ass shit bro

# What do animals do.
## Try to survive, be playful.

## Survive.
### Search for food
### Eat food

## Playful
### Find other animals
### Group up
### Play (chase each other)

## Get attacked
### Fight or flight

### Fight.
#### Stays and fights, evades, dashes towards attacker

### Flight
#### Dash away and move away
#### Or. Dash away and group up

var slimeAnims : SlimeAnimations
var search_food_state : SearchState
var wandering_state : WanderState
var idle_state : Idle_State
var pickup_state : PickUpState
var move_to_food_state : MoveToPointState
var flee_state :FleeState
var escape_state :EscapeState

@export var wanderPoint :Vector2
@export var isWandering :bool
@export var isRecovering :bool
@export var wanderDist : float
var currentDist
@export var rot : Vector2
@export var savedPoint: Vector2
var staminaRecovered : float
@export var foodPoint : Vector3
#var tileLocals : Array[Vector2]
var foodCollision
#var tileMap : TileMap
var pickupTween : Tween
var tileData : TileData
var tiles
var localFoodPos
var emptyPoly
var mob_type
var escape_point
var stats : SlimeStats
var wanderPoly
var tilePoly
var wanderCalled
var searchCalled

var food_point: Vector2:
	get:
		return Vector2(foodPoint.x, foodPoint.y)

func _setup():
	super()
	hittable.OnHit.connect(_OnHit)
	wanderCalled = 0
	searchCalled = 0
	slimeAnims = SlimeAnimations.new()
	slimeAnims._setup(get_parent().get_node("AnimationTree"))
	
	
	idle_state = Idle_State.new("Idle",rootState,self,slimeAnims)
	idle_state.setup_vars(staminaTimer,staminaRecoveryDuration)
	
	wandering_state = WanderState.new("Wander",rootState,self,slimeAnims)
	wandering_state.setup_vars(sightCast,wanderCast,staminaUsagePerUnit,wanderRange,prng)
	
	search_food_state = SearchState.new("Search Food", rootState,self,slimeAnims)
	search_food_state.setup_vars(sightCast,wandering_state,lowInv)
	
	move_to_food_state = MoveToPointState.new("Move to Food", search_food_state,self,slimeAnims)
	move_to_food_state.setup_vars(search_food_state)
	
	pickup_state = PickUpState.new("Pick Up", move_to_food_state,self,slimeAnims)
	pickup_state.setup_vars(search_food_state,food_min_dist,"resource_amount",lowInv)
	
	flee_state = FleeState.new("Flee", rootState,self,slimeAnims)
	
	escape_state = EscapeState.new("Escape", flee_state,self,slimeAnims)
	escape_state.setup_vars(food_min_dist,flee_state)

	emptyPoly = preload("res://test_poly.tscn")
	#wanderPoly = create_empty("Wander", Vector2.ZERO,Color.GREEN_YELLOW)
	tilePoly = create_empty("Tile", Vector2.ZERO,Color.DARK_VIOLET)

	stats = SlimeStats.new(stats_resource)
	stats._set_max()
	savedPoint = mobMovement.global_position

	staminaTimer.timeout.connect(recover_stamina)
	ai_enabled = true

func _OnHit(healthChange):
	var currentStat = stats.health
	if(currentStat + healthChange < 0):
		stats.health = 0
		var mobSpawner = get_parent().get_parent()
		mobSpawner.respawn_timer(mob_type)
		get_parent().queue_free()
		return
	stats.health += healthChange
	print("Health: ", stats.health)

func create_empty(nm,pos, clr):
	var empty = emptyPoly.instantiate()
	empty.name = nm
	var root = get_node("/root")
	root.add_child.call_deferred(empty)
	empty.position = pos
	var child = empty.get_child(0)
	child.modulate = clr
	return empty

func _use_root():
	slimeAnims._still()
	mobMovement.stopMovement()

#func set_wander_state():
	#wandering_state = AIState.new()
	#wandering_state.setup(func():
		#return (stats.stamina > stats.stamina_max/2.0)
		#, wander,1,"Wander",rootState)
#
#func set_idle_state():
	#idle_state = AIState.new()
	#idle_state.setup(func():
		#return stats.stamina <= stats.stamina_max/2.0
		#, idle,5,"Idle", rootState)
	#idle_state.loop = false
	#idle_state.onExitFunction = reset_idle_state
	#idle_state.onEnterFunction = func(): slimeAnims._idle()
#
#func reset_idle_state():
	#staminaRecovered = 0
	#staminaTimer.stop()
##	isRecovering = false

#func set_search_state():
	#search_food_state = AIState.new()
	#search_food_state.setup(func():
##		print("inv: ", stats.inv_space, "\n", stats.inv_space > lowInv)
		#return (stats.inv_space > lowInv &&
		#stats.stamina > stats.stamina_max/2.0)
		#,searchForFood,1,"Search",rootState)

#func set_pickup_state():
	#pickup_state = AIState.new()
	#pickup_state.setup(func():
		#return (mobMovement.global_position.distance_to(food_point) < food_min_dist),
		#pickUp,1,"Pick up",move_to_food_state)
	#pickup_state.loop = false
	#pickup_state.onEnterFunction = func():
		#print("Distance: ",to_global(mobMovement.position).distance_to(food_point) )
		#slimeAnims.attack()
		#mobMovement.stopMovement()
#
#func set_move_to_food_state():
	#move_to_food_state = AIState.new()
	#move_to_food_state.setup(func():
##		print("\nfood point is: ", foodPoint.z, "\nmove to food: ", foodPoint.z > 0.0)
		#return foodPoint.z > 0.0,
		#func(): mobMovement.moveToPoint(food_point),1,
		#"Move to food",search_food_state)
	#move_to_food_state.onEnterFunction = func():
		#mobMovement.stopMovement()
		#slimeAnims._walk()
	#
#func set_flee_state():
	#flee_state = AIState.new()
	#flee_state.setup(func():
		#flee_state.chance = remap(stats.health,
		#stats.health_max/2.0 ,stats.health_max,50,0)
		#return stats.health < stats.health_max / 2.0
		#,flee,0,"Flee",rootState)
	#priority_states.append(flee_state)
##
#func set_escape_state():
	#escape_state = AIState.new()
	#escape_state.setup(func():
		#return mobMovement.global_position.distance_to(escape_point) < food_min_dist
		#,escape,5,"Escape",flee_state)

func recover_stamina():
	currentState.allowExit = staminaRecovered > staminaRecoveryMinimum
	if(stats.stamina < stats.stamina_max):
		var recovery = prng.range_f(staminaRecovery.x,staminaRecovery.y)
		stats.stamina += recovery
		staminaRecovered += recovery
		print("Recovering stamina: ", stats.stamina)
#
#func flee():
	#var mobSpawner = get_parent().get_parent()
	#var spawn_points = mobSpawner.spawn_dict[mob_type]
	#var dist =9999
	#var nearest_spawn_point
	#for spawn_point in spawn_points:
		#var spawn_dist = spawn_point.distance_to(mobMovement.position)
		#if(spawn_dist< dist):
			#dist = spawn_dist
			#nearest_spawn_point = spawn_point
	#escape_point = nearest_spawn_point
	#mobMovement.moveToPoint(nearest_spawn_point,1.5)

#func escape():
	#var mobSpawner = get_parent().get_parent()
	#mobSpawner.respawn_timer(mob_type)
	#queue_free()

#func idle():
	#mobMovement.stopMovement()
##	if(!isRecovering):
	#staminaTimer.start(staminaRecoveryDuration)
##		isRecovering = true
		#
#
#func to_degrees(radians) -> float:
	#return radians * 180.0 / PI;
#
#func get_angle(point, center)-> float:
	#var delta = (point - center).normalized()
	#var relPoint = delta
	#return to_degrees(atan2(relPoint.y, relPoint.x))-90.0

func _get_label_text()-> String:
	var str : String = super()

	return str

#func wander(speed_multiplier = 1.0, stamina_multiplier = 1.0):
	##var pos = to_global(mobMovement.position)
	#wanderCalled+=1
	#var pos = mobMovement.global_position
	#var maxDist = 1.0
	#tilePoly.position = pos
	#if(!isWandering):
		#wanderDist = prng.range_f(wanderRange.x,wanderRange.y)
		#rot = prng.random_unit_circle(true)
		##wanderPoint = mobMovement.to_global(rot * wanderDist) + savedPoint
		#wanderPoint = (rot * wanderDist) + pos
		#sightCast.rotation_degrees = get_angle(wanderPoint, mobMovement.global_position)
		#wanderCast.global_position = wanderPoint
		##isWandering = check_valid_box_pos(wanderPoint,3)
		#maxDist = pos.distance_to(wanderPoint)
		##wanderPoly.position = wanderPoint
		#if(isWandering):
			#slimeAnims._walk()
	#isWandering = !wanderCast.is_colliding()
	##var child = wanderCast.get_child(0)
	##child.modulate = Color.AQUAMARINE if isWandering else Color.RED
	#currentDist = pos.distance_to(wanderPoint)
	#if(currentDist < 1.0  && isWandering):
		#isWandering = false
		#stats.stamina -= (wanderDist * staminaUsagePerUnit * stamina_multiplier);
		##print("Wandering complete!\nWander Dist: ", wanderDist, 
		##"\nDist: ", currentDist,
		 ##"\nPoint: ", wanderPoint,
		##"\nRot: ",rot,
		##"\nStamina: ",stats.stamina,"\n")
		#mobMovement.stopMovement()
	##var dynamic_speed = remap(currentDist,maxDist,1.0,speed_multiplier,speed_multiplier*0.25)
	#mobMovement.moveToPoint(wanderPoint,speed_multiplier, currentDist > 20.0)

#func searchForFood():
	#searchCalled += 1
	#if(!sightCast.is_colliding()):
		##print("No collision found %s" % get_parent().name)
		#wander(2.0,0.1)
		#return
	#
	#var valid_cols = sightCast.collision_result
	#var dist = 999.0
	#var pos
	#var col
	#
	#for i in sightCast.get_collision_count():
		##print(valid_cols[i].name)
		##print(valid_cols[i].get_type())
		#var valid_col = sightCast.get_collider(i)
		##var cpos = to_global(valid_col.point)
		#var cpos = (valid_col.global_position)
		##var globPos = to_global(mobMovement.position)
		#var globPos = mobMovement.global_position
		#var globPosMove = mobMovement.to_global(mobMovement.position)
		#var posDist = globPos.distance_to(cpos)
		#print("found food: ", cpos ,
		#"\nglobal: ", globPos, 
		#"\nDist: ", posDist,
		#"\nGlobal move pos:", globPosMove)
#
		#if(posDist < dist):
			#pos = cpos
			#col = sightCast.get_collider(i)
			#dist = posDist
	#
	#
	#
	#if(dist < 999.0):
		#foodPoint = Vector3(pos.x,pos.y,1.0)
		#foodCollision = col
		#print("food point set ", foodPoint)
	#else:
		#foodPoint = Vector3(0,0,0)
#
#func pickUp():
##	localFoodPos = tileMap.to_local(Vector2(foodPoint.x,foodPoint.y)/ tileMap.scale)  
#
	##foodPoly.position = food_point
##	var cell = tileMap.local_to_map(localFoodPos)
##	tileData = tileMap.get_cell_tile_data(4,cell)
	#
#
##	if tileData != null:
	#if foodCollision != null:
##		tilePoly.position = to_global(tileMap.map_to_local(tileData.texture_origin))
##		var resourceAmount = tileData.get_custom_data_by_layer_id(0)
		#var resourceAmount = foodCollision.get_meta("resource_amount")
		#if(resourceAmount == null):
			#return
##		print("resource amount: ", resourceAmount)
		#if(resourceAmount > 0):
			#currentState.allowExit = false
			#pickupTween = get_tree().create_tween()
			#pickupTween.tween_method(set_inv_space,stats.inv_space,
			#stats.inv_space-resourceAmount,0.5 * resourceAmount)
			#pickupTween.tween_callback(func():
				#foodCollision.OnPickUp.emit(foodCollision,
				#func():
					#foodPoint.z = 0
					#currentState.allowExit = true,
					#10.0 * resourceAmount))
			#
##			pickupTween.tween_callback(func():
##				tileMap.remove_tile(tileData,2.0 * resourceAmount,
##				resourceAmount,
##				func(): foodPoint.z = 0)
##				currentState.allowExit = true)
		#
	
	
	
#func set_inv_space(x):
	#if(x > lowInv):
		#stats.inv_space = x
	#else:
		#stats.inv_space = lowInv
	#var t = HelperFunctions.remap(stats.inv_space,Vector2(lowInv,stats.inv_space_max),Vector2(0.0,1.0))
	#if(sprite.material != null):
		#sprite.material.set_shader_parameter("multiplier",lerp(0.0, 0.75,1.0-t))
	#print("inv: ",stats.inv_space)
	
