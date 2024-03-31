extends Node


class_name AIState


var chance : int
var max_times_called : int
var condition : Callable
var stateFunction: Callable
var onEnterFunction: Callable
var onExitFunction: Callable
var stateName : String
var states : Array[AIState]
var parentState
var allowExit
var loop
var called
var called_amount
var ai
var anims

func _init(p_stateName, p_parentState, p_AI, p_anims, p_max_times = -1):
	stateName = p_stateName
	parentState = p_parentState
	ai = p_AI
	anims = p_anims
	max_times_called = p_max_times
	called_amount = 0
	_pre_setup()

func setup(p_condition:Callable, p_stateFunction:Callable, p_chance: int):
	called = false
	allowExit= true
	condition = p_condition
	stateFunction = p_stateFunction
	chance = p_chance
	#stateName = p_stateName
	#parentState = p_parentState
	loop = true
	#_pre_setup(p_parentState,p_slime_AI, p_slime_anims)
	if(parentState != null):
		parentState.add_state(self)

func _pre_setup():
	pass
func remove_self():
	if(parentState != null):
		parentState.states.erase(self)
func add_state(state: AIState):
	states.append(state)
	
func is_usable()-> bool:
	if(condition == null):
		return true
	
	var call = condition.call()
	
	if(parentState != null):
		call = call && parentState.is_usable()
	
#	print(stateName, " is usable: ", call)
	return call

func _on_enter():
	pass
	#if(onEnterFunction.is_null()):
		#return
	#onEnterFunction.call()

func _on_exit():
	called = false
	called_amount = 0
	#if(onExitFunction.is_null()):
		#return
	#onExitFunction.call()

func use():
	if(stateFunction == null):
		return
		
	if(!loop && called):
		return
	if(!loop && !called):
		called = true
	
	stateFunction.call()
