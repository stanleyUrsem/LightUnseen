extends Node


class_name PRNG

var prng : RandomNumberGenerator
var seed


func _init(p_seed):
	seed = p_seed
	prng = RandomNumberGenerator.new()
	prng.seed = seed

func value():
	var maxExclusive = 1.0000000004656612875245796924106
	return prng.randf() * maxExclusive
	
func range_i(range: Vector2i)->int:
	return prng.randi_range(range.x,range.y)
	
func range_i_mn(min,max)->int:
	return prng.randi_range(min,max)
	
func range_f(min, max)-> float:
	return lerp(min,max,prng.randf())
	
func range_f_v(minMax)-> float:
	return lerp(minMax.x,minMax.y,prng.randf())
	
func range_to_float(range: Vector2i, div = 100.0):
	return range_i(range) / div
	

func look_up_value(weightedtable : Array[WeightedTuple],x: int):
	var cumulativeWeight = 0
	
	for i in weightedtable.size():
		cumulativeWeight += weightedtable[i].weight
		if(x < cumulativeWeight):
			return weightedtable[i].value
	
	return weightedtable[0].value

#source: https://www.redblobgames.com/articles/probability/damage-rolls.html
func weighted_range(weightedtable : Array[WeightedTuple]):
	var sumOfWeight = 0
	
	for i in weightedtable.size():
		sumOfWeight += weightedtable[i].weight
	
	var x = range_i_mn(0,sumOfWeight)
	return look_up_value(weightedtable,x)



func random_unit_circle(inside)-> Vector2:
	var theta = lerp(0.0,360.0,value())
	var radius = value()
	
	if(inside):
		return Vector2(radius * cos(theta),radius * sin(theta))
	else:
		return Vector2(cos(theta),sin(theta))

func random_unit_area(inside) -> Vector2:
	var val = 0.5
	var x = range_f(-val,val)
	var y = range_f(-val,val)
	
	var p = Vector2(x,y)
	
	if(!inside):
		var axis = prng.range(0,2)
		p[axis] = -val if p[axis] < 0.0 else val
	
	return p


func point_on_torus(curveRad,pipeRad, u, v)-> Vector2:
	var r = (curveRad + pipeRad * cos(v))
	var x = r * sin(u)
	var y = r * cos(u)
	
	return Vector2(x,y)

func random_torus(amountSpheres,outerRadius,innerRadius, inside)-> Vector2:
	var step = (PI * 2.0) / amountSpheres
	var index = range_i_mn(0, amountSpheres)
	
	return (random_unit_circle(inside) * outerRadius) + point_on_torus(1,innerRadius,step * index,0.0) 



func random_element(array):
	return array[range_i_mn(0,array.size())]



	
	
	
