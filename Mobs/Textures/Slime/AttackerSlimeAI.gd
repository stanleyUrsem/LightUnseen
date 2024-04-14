extends SlimeAI

class_name AttackerSlimeAI

@export var circleRoundRadius : float
@export var circleMinDist : float
@export var circleRoundAngleRange : Vector2
@export var stamina_usage : float
@export var slamAttackStats : SkillStats
@export_file() var skillHitPath : String
@export var attackArtRoot : Node2D
@export var hitMarkerRoot : Node2D
@export var leftBottomMarker : Marker2D
@export var rightTopMarker : Marker2D
@export var searchTransition : AnimationTransition
@export var stopAttackTransition : AnimationTransition
@export var stopAttackLoopTransition : AnimationTransition
@export var attackTransition : AnimationTransition
#@export var animTree : AnimationTree
@export var call_backup_health : float
@export var call_backup_amount : int
var searchPlayerState : SearchPlayerState
var moveToPlayerState : MoveToPlayerState
var circleAroundState : CircleAroundState
var attackState : AttackState
var callBackUpState : CallBackupState


func _setup():
	super()
	
	searchPlayerState = SearchPlayerState.new("Search Player",rootState,self,slimeAnims,250)
	searchPlayerState.setup_vars(sightCast,wandering_state,searchTransition,
	stopAttackTransition,stopAttackLoopTransition)
	states.append(searchPlayerState)
	moveToPlayerState = MoveToPlayerState.new("Move to Player", searchPlayerState,self,slimeAnims)
	states.append(moveToPlayerState)
	circleAroundState = CircleAroundState.new("Circle Around", moveToPlayerState,self,slimeAnims)
	circleAroundState.setup_vars(circleRoundRadius,circleRoundAngleRange,
	wanderCast,prng,stamina_usage,circleMinDist)
	states.append(circleAroundState)
	attackState = AttackState.new("Attack", circleAroundState,self,slimeAnims)
	attackState.setup_vars(slamAttackStats,skillHitPath,
	leftBottomMarker,rightTopMarker,attackArtRoot,AttackState.AttackType.DYNAMIC_SIZED,attackTransition)
	states.append(attackState)
	callBackUpState = CallBackupState.new("Call Back Up", rootState,self,slimeAnims)
	callBackUpState.setup_vars(call_backup_health,call_backup_amount)
	priority_states.append(callBackUpState)
	states.append(callBackUpState)
	disable_states()
	set_state(rootState)
	ai_enabled = true
	
func attack_done():
	print("Attack done")
	attackState.allowExit = true
	attackState.reset()
func _get_label_text()-> String:
	var str = super()	
	var dist = "%s\nDt Player: %f\nDt crnt: %f\nCrnt state called: %d\nVel: %v
	\nDt crnt: %f\nDt max: %f" % [str,circleAroundState.distPlayer
	,circleAroundState.currentDist,currentState.called_amount,mobMovement.velocity,
	wandering_state.currentDist,wandering_state.maxDist] 
	return dist
func rotate_to_target():
	print("Rotate to target")
	if(player != null):
		var target = player.global_position
		var angle =	HelperFunctions.get_angle(mobMovement.global_position,
		target)
	
		attackArtRoot.rotation_degrees = angle + 180
	#hitMarkerRoot.rotation_degrees = angle + 180
func reset_rotation():
	print("Reset rotation")
	attackArtRoot.rotation_degrees = 0
	#hitMarkerRoot.rotation_degrees = 0
	attack_done()
func create_hit():
	print("Create hit %d" % attackArtRoot.rotation_degrees)
	attackState.create_hit()
func _physics_process(delta):
	super(delta)
	
	if(attackState != null):
		attackState.update_cooldown(delta)
