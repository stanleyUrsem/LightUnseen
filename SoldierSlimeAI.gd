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
@export var reset_pos_duration : float
var attackState : AttackState
var attack_dir : Vector2
var commander_ai : commander_slime_ai
var reset_pos : Vector2
var reset_pos_current_t : float
var resetting_pos : bool
func _setup():
	super()
	attackState = AttackState.new("Attack", rootState,self,slimeAnims)
	attackState.setup_vars(attackStats,skillHitPath,
	leftBottomMarker,rightTopMarker,attackArtRoot,
	attack_type,attackTransition)
	attackState.allowExit = true
	
	ai_enabled = true
func on_death():
	if(commander_ai != null):
		if(commander_ai.gatherer_slimes.has(self)):
			commander_ai.gatherer_slimes.erase(self)
		if(commander_ai.solid_slimes.has(self)):
			commander_ai.solid_slimes.erase(self)
	super()
func attack_forward(dir):
	#attack_done()
	attack_dir = dir
	leftBottomMarker.global_position = dir
	if(currentState != attackState):
		set_state(attackState)
func move_and_attack(pos,dir,dist):
	if(mobMovement.global_position.distance_to(pos) < dist):
		attack_forward(dir)
	if(currentState != attackState):
		move_to(pos)
func move_to(pos):
	mobMovement.moveToPoint(pos,1.0)
	slimeAnims._walk()

	#set_state(wandering_state)
	#wandering_state.wander_to(pos,3.0,0.25)
func rotate_to_target():
	print("Rotate to target")
	var target = attack_dir + mobMovement.global_position
	var angle =	HelperFunctions.get_angle(mobMovement.global_position,
	target)
	if(attackArtRoot != null):
		attackArtRoot.rotation_degrees = angle + 180
	#hitMarkerRoot.rotation_degrees = angle + 180
func reset_rotation():
	print("Reset rotation")
	if(attackArtRoot != null):
		attackArtRoot.rotation_degrees = 0
	#hitMarkerRoot.rotation_degrees = 0
	attack_done()
func reset_position():
	reset_pos_current_t = reset_pos_duration
	#get_parent().global_position =  commander_ai.global_position
	reset_pos = get_parent().global_position
	resetting_pos = true
func attack_done():
	#pass
	attackState.allowExit = true
	#attackState.reset()	
func create_hit():
	#print("Create hit %d" % attackArtRoot.rotation_degrees)
	attackState.create_hit()
func _physics_process(delta):
	super(delta)
	if(resetting_pos):
		reset_pos_current_t -= delta
		var alpha = remap(reset_pos_current_t,reset_pos_duration,
		0.0,0.0,1.0)
		get_parent().global_position = lerp(reset_pos,
		commander_ai.global_position,alpha)
		if(alpha >= 1.0):
			resetting_pos = false
	if(attackState != null):
		attackState.update_cooldown(delta)
