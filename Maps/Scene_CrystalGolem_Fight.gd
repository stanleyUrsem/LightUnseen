extends Node2D

@export var crystal_golem_ais : Array[AI]
@export var cutsceneDirector : CutsceneDirector

var amount : int = 0

func _ready():
	for golem in crystal_golem_ais:
		golem.OnAIDeath.connect(resume_scene)

func resume_scene():
	amount+= 1
	if(amount == crystal_golem_ais.size()):
		cutsceneDirector.resume()
	
