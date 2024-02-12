extends Node2D

class_name AbilityAction


@export var fadeTimer : Timer
var obtainCondition : Callable
@export var data : AbilityData
var damage
var isSetup : bool
var isHit : bool
var direction
var user : Node2D
var mouseHandler
var saved_fade
var delta_time
var prng : PRNG
func _setup(p_data : AbilityData, useLocation , p_user : Node2D, p_MouseHandler, p_direction,p_prng):
	if(p_data != null):
		data = p_data
	user = p_user
	prng = p_prng
	mouseHandler = p_MouseHandler
	position = useLocation
	damage = data.damage
	print("Speed: %d" % data.speed)
	isSetup = true
	isHit = false
	saved_fade = fadeTimer.wait_time
	fadeTimer.timeout.connect(func(): queue_free())
	direction = (_GetMouseDirection() if data.useMouseAim else p_direction)
	_on_setup()
	#print(direction)

func _on_setup():
	pass

func _physics_process(delta):
	delta_time = delta
	#if(isSetup):
		#_Move()

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

func _ApplyDamage(collision):
	var hit = collision.get_collider().get_node_or_null("Collider")
	if(hit is Hittable):
		hit.OnHit.emit(-damage)
		return hit
	return null

func _OnHit(collision):
	if(isHit): return
	isHit = true

func _OnUse():
	pass
