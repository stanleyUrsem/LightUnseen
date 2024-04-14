extends NPC

class_name ReginaldNPC

@export var scene_10 : CutsceneDirector
@export var scene_aftermath : CutsceneDirector
@export var attackRoot : Node2D
@export var leftBot : Node2D
@export var rightTop :Node2D
@export var attack_position_holder : Node2D
@export var laser_spots : Array[Marker2D]
@export var chainsaw_spots : Array[Marker2D]
@export var orb_spots : Array[Marker2D]
@export var bomb_spots : Array[Marker2D]

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
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"
var att_1_state : NPCAttackState
var att_2_state : NPCAttackState
var att_3_state : NPCAttackState
var att_4_state : NPCAttackState
var enraged : bool
var chosen_spots : Array[Marker2D]
var laser_patterns : Array[LaserPattern]
var current_laser_pattern : LaserPattern
var current_laser_pattern_index : int
func setup_positions(index,array):
	var root = attack_position_holder.get_child(index)
	for i in root.get_child_count():
		var marker = root.get_child(i)
		array.append(marker)
		
func on_death():
	ai_enabled = false
	if(scene_10 == null):
		scene_aftermath.play_scene()
	else:
		scene_10.play_scene()
	slimeAnims.death()

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
	leftBot,rightTop,attackRoot,AttackState.AttackType.DYNAMIC_SIZED,
	att_4_animTrans)
	
	setup_positions(0,chainsaw_spots)
	setup_positions(1,laser_spots)
	setup_positions(2,orb_spots)
	setup_positions(3,bomb_spots)
	player = playerTransformer.active_form
	playerTransformer.on_form_changed.connect(player_form_changed)
	disable_states()
	setup_laser_patterns()
	
	if(saveManager.loaded_data.has("npc_amount_killed")):
		var amount = saveManager.loaded_data["npc_amount_killed"]
		if(amount > 0):
			enraged = true
		else:
			eventsManager.OnNpcKilled.connect(set_enraged)
func set_enraged(x):
	enraged = true
	eventsManager.OnNpcKilled.disconnect(set_enraged)
	
func player_form_changed(x):
	player = x
func create_laser_pattern(p_1,p_2,p_3,p_4,p_5,p_6,p_7):
	var pattern = LaserPattern.new(Vector3i(p_1,p_2,p_3),
	Vector3i(p_4,p_5,-1),Vector3i(p_6,p_7,-1))
	
	return pattern
	
func setup_laser_patterns():
	laser_patterns.append(create_laser_pattern(0,1,2,3,4,5,6))
	laser_patterns.append(create_laser_pattern(2,3,4,5,6,-1,-1))
	laser_patterns.append(create_laser_pattern(1,0,-1,3,4,-1,-1))
	laser_patterns.append(create_laser_pattern(3,4,-1,5,6,2,-1))
	laser_patterns.append(create_laser_pattern(5,6,-1,2,-1,1,0))
func set_laser_pattern():
	current_laser_pattern = prng.random_element(laser_patterns)
	current_laser_pattern_index = 0
	if(enraged):
		create_laser()
		current_laser_pattern = prng.random_element(laser_patterns)
		current_laser_pattern_index = 0
func create_laser():
	#var index = 0
	#var amount_lasers = prng.range_i_mn(3,laser_spots.size()-1)
	#var laser_pattern = prng.random_element(laser_patterns)
	for i in range(3):
		#var laser_spot = prng.random_element(laser_spots)
		var spots = current_laser_pattern.spots[current_laser_pattern_index]
		var spot_index = spots[i]
		if(spot_index < 0):
			continue
		var laser_spot = laser_spots[spot_index]
		#while(chosen_spots.has(laser_spot)):
			#laser_spot = prng.random_element(laser_spots)
		#chosen_spots.append(laser_spot)
		att_4_state.attackRoot = laser_spot.get_child(0)
		att_4_state.leftBot = laser_spot.get_child(0)
		att_4_state.rightTop = laser_spot.get_child(1)
		
		var hit = att_4_state.create_hit()
		print("Laser created at: %v" % hit.global_position)
	current_laser_pattern_index += 1
	#chosen_spots.clear()
func laser_done():
	att_4_state.allowExit = true
	set_state(idle_state)
	att_4_state.reset()
	
func chainsaw_done():
	att_1_state.allowExit = true
	set_state(idle_state)
	att_1_state.reset()
	
func orb_done():
	att_2_state.allowExit = true
	set_state(idle_state)
	att_2_state.reset()
	
func bomb_done():
	att_3_state.allowExit = true
	set_state(idle_state)
	att_3_state.reset()			
	
func create_chainsaw():
	var saw_amount = 2
	if(enraged):
		saw_amount *= 2
	for i in range(saw_amount):
	#for chainsaw_spot in chainsaw_spots:
		var chainsaw_spot = prng.random_element(chainsaw_spots)
		while(chosen_spots.has(chainsaw_spot)):
			chainsaw_spot = prng.random_element(chainsaw_spots)
		chosen_spots.append(chainsaw_spot)
		att_1_state.attackRoot = chainsaw_spot.get_child(0)
		att_1_state.leftBot = chainsaw_spot.get_child(0)
		att_1_state.rightTop = chainsaw_spot.get_child(1)
		
		var hit = att_1_state.create_hit()
		
		#if(enraged):
			#hit.scale *= 2.0
		print("Chainsaw created at: %v" % hit.global_position)
	chosen_spots.clear()

func create_orbs():
	var orb_amount = 2
	if(enraged):
		orb_amount *= 2
	for i in range(orb_amount):
		var spot_1 = prng.random_element(orb_spots)
		
		while(chosen_spots.has(spot_1)):
			spot_1 = prng.random_element(orb_spots)
			
		chosen_spots.append(spot_1)
		
		att_2_state.attackRoot = spot_1
		att_2_state.leftBot = spot_1
		att_2_state.rightTop = spot_1
		att_2_state.create_hit()
		
		var spot_2 = spot_1.get_child(0)
		
		att_2_state.attackRoot = spot_2
		att_2_state.leftBot = spot_2
		att_2_state.rightTop = spot_2
		var hit = att_2_state.create_hit()
		
	chosen_spots.clear()

func create_bombs():
	var bomb_amount = 4
	if(enraged):
		bomb_amount *= 2
	
	for i in range(bomb_amount):
		var spot = prng.random_element(bomb_spots)
		
		while(chosen_spots.has(spot)):
			spot = prng.random_element(bomb_spots)
		
		chosen_spots.append(spot)
		
		att_3_state.attackRoot = spot
		att_3_state.leftBot = spot
		att_3_state.rightTop = spot
		var hit = att_3_state.create_hit()
		print("Bombs created at: %v" % hit.global_position)
		
	chosen_spots.clear()

	
class LaserPattern:
	var spots : Array[Vector3i]
	
	func _init(spot_1 : Vector3i, spot_2 : Vector3i, spot_3 : Vector3i):
		
		spots.append(spot_1)
		spots.append(spot_2)
		spots.append(spot_3)
		
		
	
	
