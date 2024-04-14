extends NPC

class_name HendersonNPC

@export var leftBot : Node2D
@export var rightTop : Node2D
@export var attackRoot : Node2D
@export var spike_radius_range : Vector2
@export var spike_amount_range : Vector2i


@export_group("Kick")
@export var kick_anim : AnimationTransition
@export_file() var kick_path : String
@export var kick_stats : SkillStats

@export_group("Float")
@export var float_anim : AnimationTransition
@export_file() var float_path : String
@export var float_stats : SkillStats

var kick_state : NPCAttackState
var float_state : NPCAttackState
var hitMarkers : Node2D
var spike_weighted_tuple : Array[WeightedTuple]
func _setup():
	super()
	hitMarkers = leftBot.get_parent()
	kick_state = NPCAttackState.new("Kick", rootState,
	self,slimeAnims)
	
	kick_state.setup_vars(kick_stats,kick_path,
	leftBot,rightTop,attackRoot,AttackState.AttackType.MOVABLE,
	kick_anim)
	
	float_state = NPCAttackState.new("Float", rootState,
	self,slimeAnims)
	
	float_state.setup_vars(float_stats,float_path,
	leftBot,rightTop,attackRoot,AttackState.AttackType.MOVABLE,
	float_anim)
	
	player = playerTransformer.active_form
	playerTransformer.on_form_changed.connect(player_form_changed)
	disable_states()
	
	spike_weighted_tuple.append(WeightedTuple.new(15,true))
	spike_weighted_tuple.append(WeightedTuple.new(75,false))
	
func player_form_changed(x):
	player = x
func create_kick_hit():
	rotate_to_target()
	var rand = prng.range_i_mn(0,1)
	var kick_allowed = rand > 0
	if(!kick_allowed):
		return
	kick_state.create_hit()
	attackRoot.rotation_degrees = 0.0
	
func on_death():
	eventsManager.OnHendersonDeath.emit()
	super()

	
func rotate_to_target():
	if(player != null):
		var offset = prng.range_i_mn(-12,12) * Vector2.ONE
		attackRoot.position = Vector2.ZERO
		leftBot.position = Vector2.ZERO
		rightTop.global_position = player.global_position + offset
		#var target = player.global_position
		#var angle =	HelperFunctions.get_angle(mobMovement.global_position,
		#target)
	#
		#attackRoot.rotation_degrees = angle + 180.0	
func kick_done():
	kick_state.allowExit = true
	set_state(idle_state)
	kick_state.reset()
	
func create_float_hit():
	var spike_amount = prng.range_f_v(spike_amount_range)
	
	for i in range(spike_amount):
		var radius = prng.range_f_v(spike_radius_range)
		var pos = prng.random_unit_circle(false) * radius
		set_spike_pos(pos)
		float_state.create_hit()
		
func set_spike_pos(pos):
	var player_pos = player.global_position
	var on_player = prng.weighted_range(spike_weighted_tuple)
	pos += player_pos
	if(on_player):
		pos = player_pos
	attackRoot.global_position = pos 
	leftBot.global_position = pos 
	rightTop.global_position = pos 
		
func float_done():
	float_state.allowExit = true
	set_state(idle_state)
	float_state.reset()
