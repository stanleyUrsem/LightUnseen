extends NPC

class_name NPC_farm_miner
@export var food_min_dist: float
@export var lowInv : int = 1

var search_food_state : SearchState
var pickup_state : PickUpState
var move_to_food_state : MoveToPointState

func _setup():
	super()
	search_food_state = SearchState.new("Search Food", rootState,self,slimeAnims)
	search_food_state.setup_vars(sightCast,
	wandering_state,lowInv,true)
	
	move_to_food_state = MoveToPointState.new("Move to Food", search_food_state,
	self,slimeAnims)
	move_to_food_state.setup_vars(search_food_state)
	
	pickup_state = PickUpState.new("Pick Up", move_to_food_state,self,slimeAnims)
	pickup_state.setup_vars(search_food_state,food_min_dist,"resource_amount",lowInv)
	
	ai_enabled = true
	#add flee state to henderson
	#add state that returns npc to their home on nightfall
	#add state to start working
