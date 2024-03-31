class_name Ability

var data : AbilityData

var isSetup : bool
var abilityAction 

func setup(p_data):
	data = p_data
	if(!data.animOnly):
		abilityAction = load(data.abilityPath)
	print(abilityAction)
	isSetup = true
	

func _can_obtain() -> bool:
	return true
	
func use(root: Node,useLocation,user, mouseHandler : MouseHandler, direction,prng):
	if(data.animOnly):
		return
	
	var a = abilityAction.instantiate() as AbilityAction
	root.add_child(a)
	a.setup_vars(data,mouseHandler)
	a._setup(useLocation,user, direction,prng)
		
