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

var attack_slam_state : AutoAttackState
var attack_slam_shoot_state : AutoAttackState
var attack_shoot_state : AutoAttackState

func _setup():
	super()
	attack_slam_state = AutoAttackState.new("Slam",rise_state,self,crystal_anims)
	attack_slam_state.setup_vars(slam_stats,slam_path,leftBot,rightTop,
	att_root,slam_type,slam_transition)
	
	attack_slam_shoot_state = AutoAttackState.new("SlamShoot",rise_state,
	self,crystal_anims)
	attack_slam_shoot_state.setup_vars(slam_shoot_stats,slam_shoot_path,
	leftBot,rightTop,
	att_root,slam_shoot_type,slam_shoot_transition)
	
	attack_shoot_state = AutoAttackState.new("Shoot",rise_state
	,self,crystal_anims)
	attack_shoot_state.setup_vars(shoot_stats,shoot_path,leftBot,rightTop,
	att_root,shoot_type,shoot_transition)
	
	ai_enabled = true

func slam_hit():
	if(player != null):
		var offset = prng.random_unit_circle(false) * 32
		leftBot.global_position = player.global_position + offset
	attack_slam_state.create_hit()
func slam_hit_done():
	attack_slam_state.allowExit = true
	set_state(idle_state)
	attack_slam_state.reset()
func slam_shoot_hit():
	if(player != null):
		leftBot.global_position = player.global_position
	leftBot.global_position += prng.random_unit_circle(false) * 5.0
	attack_slam_shoot_state.create_hit()
func slam_shoot_hit_done():
	attack_slam_shoot_state.allowExit = true
	set_state(idle_state)
	attack_slam_shoot_state.reset()
	
func shoot_hit_done():
	attack_shoot_state.allowExit = true
	set_state(idle_state)
	attack_shoot_state.reset()
func shoot_hit():
	if(player != null):
		leftBot.global_position = player.global_position
	leftBot.global_position += prng.random_unit_circle(false) * 5.0
	attack_shoot_state.create_hit()

func create_death_crystal(index: int, flip_h : bool):
	create_crystal(att_root.global_position,index,flip_h)
#
#func _physics_process(delta):
	#super(delta)
	#
	#attack_shoot_state.update_cooldown(delta)
	#attack_slam_state.update_cooldown(delta)
	#attack_shoot_state.update_cooldown(delta)
