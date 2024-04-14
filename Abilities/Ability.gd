class_name Ability

var data : AbilityData

var isSetup : bool
var abilityAction 
var left : Node2D
var right : Node2D


func setup(p_data,p_left,p_right):
	data = p_data
	if(!data.animOnly):
		abilityAction = load(data.abilityPath)
	print(abilityAction)
	left = p_left
	right = p_right
	isSetup = true
	

func _can_obtain() -> bool:
	return true
	
func use(root: Node,useLocation,user, mouseHandler : MouseHandler,
 direction,prng, p_rotation_degrees):
	if(data.animOnly):
		return
	
	var a = abilityAction.instantiate() as AbilityAction
	root.add_child(a)
	a.rotation_degrees = p_rotation_degrees
	a.setup_vars(data,mouseHandler)
	a._setup(useLocation,user, direction,prng)
	if(data.dynamic_size):
		a.setup_dynamic(left, right, data.damage, p_rotation_degrees)
		
