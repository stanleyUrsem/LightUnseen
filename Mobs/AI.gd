extends Node2D

class_name AI

@export var hittable : Hittable
@export var text_label :RichTextLabel
var rootState
var currentState : AIState
var prng : PRNG
@export var ai_enabled : bool
var priority_states : Array[AIState]

func _ready():
	_setup()

func _setup():
	prng = PRNG.new(RandomNumberGenerator.new().randf_range(-999,999))
	rootState = AIState.new("root",null,self,null)
	rootState.setup(func(): return true,_use_root,100)
	currentState = rootState
	text_label.text = currentState.name

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

func transition_to():
	if(!currentState.allowExit):
		return
	if(!currentState.is_usable()):
		print("Stopping: ", currentState.stateName)
		currentState._on_exit()
		currentState = currentState.parentState
		print("Entering: ", currentState.stateName)
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
	
	print("Stopping: ", currentState.stateName)
	currentState._on_exit()
	
	currentState = prng.weighted_range(tuple)
	print("Entering: ", currentState.stateName)
	currentState._on_enter()
func _get_label_text()-> String:
	var str : String= "%s\n%s" % [currentState.stateName, get_parent().name]
	#text_label.append_text("\n%s" % get_parent().name)
	return str

func _physics_process(delta):
	if(ai_enabled):
		transition_to()
		currentState.use()
		text_label.text = _get_label_text()








