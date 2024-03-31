extends Node

class_name ScriptManager

@export var scripts : Array[Node]


func _ready():
	for script in scripts:
		script.setup()
