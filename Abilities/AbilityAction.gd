extends SkillAction

class_name AbilityAction
var obtainCondition : Callable

@export var data : AbilityData
var mouseHandler

func setup_vars(p_data : AbilityData,p_MouseHandler):
	mouseHandler = p_MouseHandler
	if(p_data != null):
		data = p_data
		_setup_vars(data.speed,data.damage)


func _on_setup():
	isHit = false
	direction = (_GetMouseDirection() if data.useMouseAim else direction)



func _GetMouseDirection()-> Vector2:
	var mousePos = mouseHandler.mouseGlobalPos
	var pos = global_position
#	print(" ")
#	print("Mouse: ",mouseHandler.mouseClickPos)
#	print("Mouse Motion: ",mouseHandler.mouseMotionPos)
#	print("Pos: ",user.position)
#	print("Global Mouse: ",user.to_global(mouseHandler.mouseClickPos as Vector2))
#	print("Global Pos: ",user.to_global(pos))
#	print("Global Parent Pos: ",user.get_parent().to_global(pos))
#	print(" ")
	var direction = mousePos - pos
	return direction.normalized()
	


func _fadeout(time : float = 0):
	if(time > 0):
		fadeTimer.start(time)
	else:
		fadeTimer.start(saved_fade)


func _OnUse():
	pass
