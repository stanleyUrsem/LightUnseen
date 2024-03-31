extends SlimeAI

class_name SoldierSlimeAI

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
	attackState = AttackState.new("Attack", null,self,slimeAnims)
	attackState.setup_vars(attackStats,skillHitPath,
	leftBottomMarker,rightTopMarker,attackArtRoot,
	attack_type,attackTransition)
	attackState.allowExit = true

	
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
	
func create_hit():
	#print("Create hit %d" % attackArtRoot.rotation_degrees)
	attackState.create_hit()
func _physics_process(delta):
	super(delta)
	
	if(attackState != null):
		attackState.update_cooldown(delta)
