extends Node2D

class_name AI
@export var stats_resource : StatsResource
@export var hittable : Hittable
@export var text_label :RichTextLabel
@export var disabled_states : Array[String]
var rootState
var currentState : AIState
var prng : PRNG
@export var ai_enabled : bool
@export var debug: bool
@export var debug_print: bool
var priority_states : Array[AIState]
var states : Array[AIState]
var stats : Stats
var eventsManager : EventsManager
var mob_type : int
var mob_spawner 
func _ready():
	_setup()

func _setup():
	prng = PRNG.new(RandomNumberGenerator.new().randf_range(-999,999))
	rootState = AIState.new("root",null,self,null,-1)
	rootState.setup(func(): return true,_use_root,100)
	eventsManager = get_node("/root/MAIN/EventsManager")
	currentState = rootState
	hittable.OnHit.connect(_OnHit)
	text_label.text = currentState.name
func disable_states():
	for disabled_state in disabled_states:
		for state in states:
			if(state.stateName == disabled_state):
				state.remove_self()
				
func _OnHit(healthChange,user):
	
	if(stats.health <= 0.0):
		return
	
	var currentStat = stats.health
	#Check if the player hit the slime

	if(currentStat + healthChange < 0):
		#slimeAnims.death()
		on_death()
		stats.health = 0
		return
	stats.health += healthChange
	print("Health: ", stats.health)

func on_death():
	#var mobSpawner = get_parent().get_parent()
	#mob_spawner.respawn_timer(mob_type)
	eventsManager.OnEnemyKilled.emit(mob_type)
func remove():
	get_parent().queue_free()

func _use_root():
	pass

func add_state_to(state_added: AIState, to_state : AIState):
	to_state.add_state(state_added)

func add_priority_states(states):
	var prio_states : Array[AIState]
	for state in priority_states:
		if(!states.has(state) && currentState != state):
			prio_states.append(state)
	return prio_states
	
func set_state(state):
	currentState._on_exit()
	currentState = state
	currentState._on_enter()
	
func transition_to():
	if(!currentState.allowExit):
		return
	var called_too_many = currentState.called_amount >= currentState.max_times_called && currentState.max_times_called > 0
	if(!currentState.is_usable() || called_too_many):
		if(debug_print):
			print("[%s]\nStopping: %s" % [get_parent().name ,currentState.stateName])
		currentState._on_exit()
		currentState = currentState.parentState
		if(debug_print):
			print("[%s]\nEntering: %s" % [get_parent().name,currentState.stateName])
		currentState._on_enter()
		
		
		
	var usableStates : Array[AIState]
	var tuple : Array[WeightedTuple]
	var to_check_states = currentState.states
	to_check_states.append_array(add_priority_states(currentState.states))
	
	for state in to_check_states:
		if(state.is_usable()):
			usableStates.append(state)
			tuple.append(WeightedTuple.new(state.chance,state))	
			#print("Added usable state: ", state.stateName)
	
	if(tuple.size() <= 0):
		return
	if(debug_print):
		print("[%s]\nStopping: %s" % [get_parent().name ,currentState.stateName])
	currentState._on_exit()
	
	currentState = prng.weighted_range(tuple)
	if(debug_print):
		print("[%s]\nEntering: %s" % [get_parent().name,currentState.stateName])
	currentState._on_enter()
func _get_label_text()-> String:
	var str : String= "%s\n%s" % [currentState.stateName, get_parent().name]
	#text_label.append_text("\n%s" % get_parent().name)
	return str

func _physics_process(delta):
	if(ai_enabled):
		transition_to()
		currentState.use()
	if(debug):
		text_label.text = _get_label_text()








