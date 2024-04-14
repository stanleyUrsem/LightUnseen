extends SlimeAI

@export var food_min_dist: float
@export var lowInv : int = 1
@export var trail : PackedScene

var search_food_state : SearchState
var pickup_state : PickUpState
var move_to_food_state : MoveToPointState
#var flee_state :FleeState
#var escape_state :EscapeState
var searchCalled
var escape_point
var foodCollision
var pickupTween : Tween
var tileData : TileData
var tiles
var localFoodPos

@export var attackStats : SkillStats
@export_file() var skillHitPath : String
@export var attack_type : AttackState.AttackType
@export var attackArtRoot : Node2D
@export var hitMarkerRoot : Node2D
@export var leftBottomMarker : Marker2D
@export var rightTopMarker : Marker2D
@export var attackTransition : AnimationTransition
var attackState : AttackState
var attack_dir



func _setup():
	super()
	searchCalled = 0
	
	attackState = AttackState.new("Attack", rootState,self,slimeAnims)
	attackState.setup_vars(attackStats,skillHitPath,
	leftBottomMarker,rightTopMarker,attackArtRoot,
	attack_type,attackTransition)
	attackState.allowExit = false
	states.append(attackState)
	
	search_food_state = SearchState.new("Search Food", rootState,self,slimeAnims)
	search_food_state.setup_vars(sightCast,wandering_state,lowInv)
	states.append(search_food_state)
	move_to_food_state = MoveToPointState.new("Move to Food", search_food_state,self,slimeAnims)
	move_to_food_state.setup_vars(search_food_state)
	states.append(move_to_food_state)
	pickup_state = PickUpState.new("Pick Up", move_to_food_state,self,slimeAnims)
	pickup_state.setup_vars(search_food_state,food_min_dist,"resource_amount",lowInv)
	states.append(pickup_state)
	#flee_state = FleeState.new("Flee", rootState,self,slimeAnims)
	#
	#escape_state = EscapeState.new("Escape", flee_state,self,slimeAnims)
	#escape_state.setup_vars(food_min_dist,flee_state)
	disable_states()
	currentState = rootState
	ai_enabled = true

func attack_forward(dir):
	attack_dir = dir
	leftBottomMarker.position = dir
	set_state(attackState)
func move_to(pos):
	set_state(wandering_state)
	wandering_state.wander_to(pos,3.0,0.25)
func rotate_to_target():
	print("Rotate to target")
	var target = Vector2.ZERO
	var angle =	HelperFunctions.get_angle(mobMovement.global_position,
	target)
	if(attackArtRoot != null):
		attackArtRoot.rotation_degrees = angle + 180
	hitMarkerRoot.rotation_degrees = angle + 180
func reset_rotation():
	print("Reset rotation")
	if(attackArtRoot != null):
		attackArtRoot.rotation_degrees = 0
	hitMarkerRoot.rotation_degrees = 0
func aim_to_player():
	if(player != null):
		#attackArtRoot.global_position = player.global_position
		var offset = prng.random_unit_circle(true) * 2.0
		leftBottomMarker.global_position = player.global_position + offset
		rightTopMarker.position = Vector2.ZERO
	else:
		#attackArtRoot.position = prng.random_unit_circle(false) * 50.0
		leftBottomMarker.position = prng.random_unit_circle(false) * 50.0	
		rightTopMarker.position = Vector2.ZERO
				
func create_hit():
	#print("Create hit %d" % attackArtRoot.rotation_degrees)
	aim_to_player()
	attackState.create_hit()
func attack_done():
	attackState.reset()
	attackState.allowExit = true
func _use_root():
	mobMovement.resetMovement()
func _physics_process(delta):
	super(delta)
	
	if(attackState != null):
		attackState.update_cooldown(delta)
		
func create_trail():
	var created_trail = trail.instantiate()
	add_child(created_trail)

	
