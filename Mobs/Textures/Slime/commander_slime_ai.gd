extends SlimeAI

class_name commander_slime_ai


@export var on_surround_start : AnimationTransition
@export var on_surround_end_one_shot : AnimationTransition
@export var on_surround_end : AnimationTransition

@export var on_defense_start : AnimationTransition
@export var on_defense_end_one_shot : AnimationTransition
@export var on_defense_end : AnimationTransition

@export var on_backup_start : AnimationTransition
@export var on_backup_end_one_shot : AnimationTransition
@export var on_backup_end : AnimationTransition

@export var gatherer_slime : PackedScene
@export var solid_slime : PackedScene
@export var surround_size : float
@export var surround_cooldown : float
@export var defense_cooldown : float

@export var solid_slime_max : int
@export var solid_slime_cost : float
@export var gatherer_slime_max : int
@export var gatherer_slime_cost : float

@export var mana_recovery : float
@export var mana_low : float

var surround_player_state : Surround_player_state
var defense_line_state : Defense_Line_State
var spawn_backup_state : Spawn_back_up_state
var recover_mana_state : Mana_Recovery_State

var solid_slimes : Array[Node2D]
var gatherer_slimes : Array[Node2D]
var mobSpawner : MobSpawner
func _setup():
	super()
	mobSpawner = get_node("/root/MAIN/MobSpawner")
	surround_player_state = Surround_player_state.new("Surround Player",
	rootState,self,slimeAnims,5)
	surround_player_state.setup_vars(surround_size,on_surround_start,
	on_surround_end_one_shot,on_surround_end,surround_cooldown,30.0,75.0)
	states.append(surround_player_state)
	
	defense_line_state = Defense_Line_State.new("Defense Line",
	rootState,self,slimeAnims,3)
	defense_line_state.setup_vars(surround_size,on_defense_start,
	on_defense_end_one_shot,on_defense_end,defense_cooldown,2.0,5.0)
	states.append(defense_line_state)
	
	spawn_backup_state = Spawn_back_up_state.new("Spawn backup",
	rootState,self,slimeAnims,3)
	spawn_backup_state.setup_vars(solid_slime_max,gatherer_slime_max,
	solid_slime_cost,gatherer_slime_cost,slimeAnims._animator,
	on_backup_start,on_backup_end,on_backup_end_one_shot)
	states.append(spawn_backup_state)
	
	recover_mana_state = Mana_Recovery_State.new("Recover mana",
	rootState,self,slimeAnims,2)
	recover_mana_state.setup_vars(mana_low * stats.mana_max,mana_recovery)
	states.append(recover_mana_state)
	
	ai_enabled = true
func on_death():
	ai_enabled = false
	for slime in solid_slimes:
		if(slime == null):
			continue
		slime.ai_enabled = false
		slime.stats.health = 0.0
		slime.on_death()
	for slime in gatherer_slimes:
		if(slime == null):
			continue
		slime.ai_enabled = false
		slime.stats.health = 0.0
		slime.on_death()
	super()
func spawn_slimes():
	var index = prng.range_i_mn(0,1)
	if(index == 0):
		mobSpawner.other_spawned_mobs.append(spawn_backup_state.spawn_gatherer())
	if(index == 1):
		mobSpawner.other_spawned_mobs.append(spawn_backup_state.spawn_solid())
func _physics_process(delta):
	super(delta)
	
	if(currentState == surround_player_state):
		surround_player_state.target_update(delta)
	if(currentState == defense_line_state):
		defense_line_state.target_update(delta)
