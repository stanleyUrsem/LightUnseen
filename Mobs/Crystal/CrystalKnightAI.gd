extends CrystalGolemAI


@export_group("Slam")
@export var slam_stats : SkillStats
@export_file() var slam_path : String
@export var slam_type : AttackState.AttackType
@export var slam_transition : AnimationTransition

@export_group("Slam Shoot")
@export var slam_shoot_stats : SkillStats
@export_file() var slam_shoot_path : String
@export var slam_shoot_type : AttackState.AttackType
@export var slam_shoot_transition : AnimationTransition

@export_group("Shoot")
@export var shoot_stats : SkillStats
@export_file() var shoot_path : String
@export var shoot_type : AttackState.AttackType
@export var shoot_transition : AnimationTransition

var attack_slam_state : AttackState
var attack_slam_shoot_state : AttackState
var attack_shoot_state : AttackState

func _setup():
	super()
	attack_slam_state = AttackState.new("Slam",rise_state,self,crystal_anims)
	attack_slam_state.setup_vars(slam_stats,slam_path,leftBot,rightTop,
	att_root,slam_type,slam_transition)
	
	attack_slam_shoot_state = AttackState.new("SlamShoot",rise_state,
	self,crystal_anims)
	attack_slam_shoot_state.setup_vars(slam_shoot_stats,slam_shoot_path,
	leftBot,rightTop,
	att_root,slam_shoot_type,slam_shoot_transition)
	
	attack_shoot_state = AttackState.new("Shoot",rise_state
	,self,crystal_anims)
	attack_shoot_state.setup_vars(shoot_stats,shoot_path,leftBot,rightTop,
	att_root,shoot_type,shoot_transition)
	
	ai_enabled = true

func slam_hit():
	attack_slam_state.create_hit()
func slam_shoot_hit():
	attack_slam_shoot_state.create_hit()
func shoot_hit():
	attack_shoot_state.create_hit()

func create_death_crystal(index: int, flip_h : bool):
	create_crystal(att_root.global_position,index,flip_h)

func _physics_process(delta):
	super(delta)
	
	attack_shoot_state.update_cooldown(delta)
	attack_slam_state.update_cooldown(delta)
	attack_shoot_state.update_cooldown(delta)
