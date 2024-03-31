extends SlimeAI

class_name commander_slime_ai

@export var gatherer_slime : PackedScene
@export var solid_slime : PackedScene
@export var surround_size : float

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

func _setup():
	super()
	
	surround_player_state = Surround_player_state.new("Surround Player",
	rootState,self,slimeAnims,5)
	surround_player_state.setup_vars(surround_size)
	
	defense_line_state = Defense_Line_State.new("Defense Line",
	rootState,self,slimeAnims,3)
	defense_line_state.setup_vars(surround_size)
	
	spawn_backup_state = Spawn_back_up_state.new("Spawn backup",
	rootState,self,slimeAnims,3)
	spawn_backup_state.setup_vars(solid_slime_max,gatherer_slime_max,
	solid_slime_cost,gatherer_slime_cost)
	recover_mana_state = Mana_Recovery_State.new("Recover mana",
	rootState,self,slimeAnims,2)
	recover_mana_state.setup_vars(mana_low * stats.mana_max,mana_recovery)
	
	
