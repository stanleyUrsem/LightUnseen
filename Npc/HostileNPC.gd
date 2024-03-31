extends NPC

class_name HostileNPC

@export var attackRoot : Node2D
@export var leftBot : Node2D
@export var rightTop :Node2D

@export_group("Attack 1")
@export var att_1_stats: SkillStats
@export_file() var att_1_hitPath : String
@export var att_1_animTrans : AnimationTransition

@export_group("Attack 2")
@export var att_2_stats: SkillStats
@export_file() var att_2_hitPath : String
@export var att_2_animTrans : AnimationTransition

@export_group("Attack 3")
@export var att_3_stats: SkillStats
@export_file() var att_3_hitPath : String
@export var att_3_animTrans : AnimationTransition

@export_group("Attack 4")
@export var att_4_stats: SkillStats
@export_file() var att_4_hitPath : String
@export var att_4_animTrans : AnimationTransition

var att_1_state : NPCAttackState
var att_2_state : NPCAttackState
var att_3_state : NPCAttackState
var att_4_state : NPCAttackState

func _setup():
	super()
	att_1_state = NPCAttackState.new("Attack 1", rootState,
	self,slimeAnims)
	
	att_1_state.setup_vars(att_1_stats,att_1_hitPath,
	leftBot,rightTop,attackRoot,AttackState.AttackType.DYNAMIC_SIZED,
	att_1_animTrans)
	
	att_2_state = NPCAttackState.new("Attack 2", rootState,
	self,slimeAnims)
	
	att_2_state.setup_vars(att_2_stats,att_2_hitPath,
	leftBot,rightTop,attackRoot,AttackState.AttackType.MOVABLE,
	att_2_animTrans)
	
	att_3_state = NPCAttackState.new("Attack 3", rootState,
	self,slimeAnims)
	
	att_3_state.setup_vars(att_3_stats,att_3_hitPath,
	leftBot,rightTop,attackRoot,AttackState.AttackType.MOVABLE,
	att_3_animTrans)
	
	att_4_state = NPCAttackState.new("Attack 4", rootState,
	self,slimeAnims)
	
	att_4_state.setup_vars(att_4_stats,att_4_hitPath,
	leftBot,rightTop,attackRoot,AttackState.AttackType.MOVABLE,
	att_4_animTrans)
