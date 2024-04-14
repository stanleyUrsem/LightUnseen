extends AI

class_name SlimeAI

@export var mobMovement : MobMovement
@export var wanderCast : ShapeCast2D
@export var wanderRange : Vector2
@export var staminaRecovery : Vector2
@export var staminaUsagePerUnit = 1.0
@export var maxPlayerDist : float
@export var staminaRecoveryDuration = 1
@export var staminaRecoveryMinimum = 20
@export var distanceMax = 1
@export var staminaTimer : Timer
@export var sightCast : ShapeCast2D
#@export var stats_resource : SlimeStatsResource
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
var wandering_state : WanderState
var idle_state : Idle_State


@export var wanderPoint :Vector2
@export var isWandering :bool
@export var isRecovering :bool
@export var wanderDist : float
@export var rot : Vector2
@export var savedPoint: Vector2
@export var foodPoint : Vector3
var staminaRecovered : float
var currentDist
var currentPlayerDist : float


#var mob_type
#var stats : SlimeStats
var wanderPoly
var wanderCalled
var player
var playerTransformer : PlayerTransformer
var food_point: Vector2:
	get:
		return Vector2(foodPoint.x, foodPoint.y)
#var eventsManager : EventsManager
var saved_pos
var update_delta : float
func _setup():
	super()
	saved_pos = mobMovement.global_position
	playerTransformer = get_node("/root/MAIN/PlayerTransformer") as PlayerTransformer
	#eventsManager = get_node("/root/MAIN/EventsManager")
	playerTransformer.on_form_changed.connect(OnPlayerTransform)
	player = null
	wanderCalled = 0
	slimeAnims = SlimeAnimations.new()
	slimeAnims._setup(get_parent().get_node("AnimationTree"))
	
	
	idle_state = Idle_State.new("Idle",rootState,self,slimeAnims,5)
	idle_state.setup_vars(staminaRecoveryDuration,
	staminaRecoveryMinimum,staminaRecovery)
	states.append(idle_state)
	
	wandering_state = WanderState.new("Wander",rootState,self,slimeAnims,5)
	wandering_state.setup_vars(sightCast,wanderCast,staminaUsagePerUnit,wanderRange,prng)
	states.append(wandering_state)

	

	stats = SlimeStats.new(stats_resource)
	stats._set_max()
	setup_health()
	savedPoint = mobMovement.global_position

func OnPlayerTransform(new_player):
	player = null

func _physics_process(delta):
	update_delta = delta
	super(delta)
	_CheckPlayerDist()

func _OnPlayerFound(p_player):
	player = p_player
func _CheckPlayerDist():
	if(player==null):
		return
	currentPlayerDist = mobMovement.global_position.distance_to(player.global_position)
	if(currentPlayerDist > maxPlayerDist):
		player = null
func _get_label_text()-> String:
	var str = super()
	if( player != null):
		str = "%s\nPlayer Dist:%f" % [str,currentPlayerDist]
	#text_label.append_text("\n%s" % get_parent().name)
	return str
func _OnHit(healthChange,user):
	print("Health %d done by %s" % [healthChange,user.name])
	if(user is CollisionObject2D && user.get_collision_layer_value(5)):
		_OnPlayerFound(user)
	super(healthChange,user)
#func _OnHit(healthChange,user):
	#
	#if(stats.health <= 0.0):
		#return
	#
	#var currentStat = stats.health
	##Check if the player hit the slime
	#if(user is CollisionObject2D && user.collision_layer == 16):
		#_OnPlayerFound(user)
	#if(currentStat + healthChange < 0):
		#slimeAnims.death()
		#stats.health = 0
		#return
	#stats.health += healthChange
	#print("Health: ", stats.health)
#
#func on_death():
	#var mobSpawner = get_parent().get_parent()
	#eventsManager.OnEnemyKilled.emit(mob_type)
	#mobSpawner.respawn_timer(mob_type)
	#get_parent().queue_free()
func on_death():
	slimeAnims.death()
	super()


func _use_root():
	slimeAnims._still()
	mobMovement.resetMovement()



#func _get_label_text()-> String:
	#var str : String = super()
#
	#return str

