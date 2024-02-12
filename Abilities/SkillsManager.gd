extends Node


class_name SkillsManager
@export var playerTransformer : PlayerTransformer
var human_skills : Array[Skill]
var slime_skills : Array[Skill]


#Skills have conditions to make them available
#Each skill needs to have a script
#Much like AI States


func _ready():
	playerTransformer.on_form_changed.connect(_add_abilities)

func _add_abilities(current_form):
	var skills
	match(current_form):
		0:
			skills = human_skills
		1:
			skills = slime_skills
		2:
			pass
			
	playerTransformer.active_form.get_node("Abilities")._setup_abilities(skills)
#make a template that has general variables that are always needed
#apply those in setup
#use signals to update the check conditions
#e.g: get hit 10 times
#subscribe to the transform to get the current player
#subscribe to the hittable of the current player
#OnHit connect to a function that increases amount hit
#when it reaches 10, add the skill to the players skills
#show notification


#in every skill that needs extra info, create a function called setup_vars
