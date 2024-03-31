extends CrystalGolemAI

@export_group("Turret")
@export var turret_stats : SkillStats
@export_file() var turret_path : String
@export var turret_type : AttackState.AttackType
@export var turret_transition : AnimationTransition


var attack_turret_state : AttackState
func _setup():
	super()
	attack_turret_state = AttackState.new("Slam",rise_state,self,crystal_anims)
	attack_turret_state.setup_vars(turret_stats,turret_path,leftBot,rightTop,
	att_root,turret_type,turret_transition)
func turrets_recovered():
	attack_turret_state.current_cooldown = 0
func deploy_turret():
	attack_turret_state.create_hit()


func create_death_crystal(index : int, flip_h : bool):
	create_crystal(att_root.global_position,index,flip_h)

