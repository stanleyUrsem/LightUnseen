class_name HelperFunctions

static func inverse_lerp(from, to, value):
	return (value- from) / (to-from)

static func remap(value, inMinMax, outMinMax):
	var rel = HelperFunctions.inverse_lerp(inMinMax.x, inMinMax.y, value)
	return lerp(outMinMax.x, outMinMax.y, rel)
	
static func to_degrees(radians) -> float:
	return radians * 180.0 / PI
	
static func get_point_from_angle(angle,radius)-> Vector2:
	var rad = angle / 180.0 * PI
	var x = cos(rad) 
	var y = sin(rad)
	return Vector2(x,y) * radius
	
static func get_angle(point, center)-> float:
	var delta = (point - center).normalized()
	var relPoint = delta
	var rad = atan2(relPoint.y, relPoint.x)
	var degrees = to_degrees(rad)
	return degrees

static func get_velocity_angle(velocity) -> float:
	var rad = atan2(velocity.y, velocity.x)
	var degrees = to_degrees(rad)
	return degrees


static func get_mouse_direction(from, mouse_handler)-> Vector2:
	var mousePos = mouse_handler.mouseGlobalPos
	var pos = from.position
#	print(" ")
#	print("Mouse: ",mouse_handler.mouseClickPos)
#	print("Mouse Motion: ",mouse_handler.mouseMotionPos)
#	print("Pos: ",from.position)
#	print("Global Mouse: ",from.to_global(mouse_handler.mouseClickPos as Vector2))
#	print("Global Pos: ",from.to_global(pos))
#	print("Global Parent Pos: ",from.get_parent().to_global(pos))
#	print(" ")
	var direction = mousePos - pos
	return direction.normalized()
