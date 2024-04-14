extends AI

class_name NPC

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
@export var sprite: Sprite2D

var wandering_state : WanderState
var idle_state : Idle_State

var slimeAnims : SlimeAnimations
@export var wanderPoint :Vector2
@export var isWandering :bool
@export var isRecovering :bool
@export var wanderDist : float
@export var rot : Vector2
@export var savedPoint: Vector2
@export var foodPoint : Vector3
var staminaRecovered : float
var currentDist

var npc_type
var wanderPoly
var wanderCalled
var player
var playerTransformer : PlayerTransformer
var saved_pos
var food_point: Vector2:
	get:
		return Vector2(foodPoint.x, foodPoint.y)
func _setup():
	super()
	saved_pos = mobMovement.global_position
	playerTransformer = get_node("/root/MAIN/PlayerTransformer") as PlayerTransformer
	wanderCalled = 0
	
	slimeAnims = SlimeAnimations.new()
	slimeAnims._setup(get_parent().get_node("AnimationTree"))
	
	idle_state = Idle_State.new("Idle",rootState,self,slimeAnims,5)
	idle_state.setup_vars(staminaRecoveryDuration,
	staminaRecoveryMinimum,staminaRecovery)
	states.append(idle_state)
	wandering_state = WanderState.new("Wander",rootState,self,slimeAnims,5)
	wandering_state.setup_vars(sightCast,wanderCast,
	staminaUsagePerUnit,wanderRange,prng,true)
	states.append(wandering_state)
	#pause ai when talked to
	#stop movement
	#unless in battle (henderson,reginald only)


	stats = SlimeStats.new(stats_resource)
	stats._set_max()
	setup_health()
	savedPoint = mobMovement.global_position

#func _physics_process(delta):
	#super(delta)
func _OnPlayerFound(p_player):
	player = p_player
		
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

func on_death():
	eventsManager.OnNpcKilled.emit(npc_type)
	slimeAnims.death()
	#get_parent().queue_free()


func _use_root():
	slimeAnims._still()
	mobMovement.resetMovement()

