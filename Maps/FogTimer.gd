extends Node

@export var material : Material
@export var duration: float

var tween : Tween
var currentHeight : int
func _ready():
	currentHeight = 0
	tween = get_tree().create_tween()
	tween.set_loops(3)
	tween.tween_method(set_shader_value,0.0,1.0,2)
	
func set_shader_value(value: float):
	material.set_shader_parameter("transition", value)
	print("value: ", value)
	if(value >= 1.0):
		currentHeight+=1
		material.set_shader_parameter("height", currentHeight)
		
	
