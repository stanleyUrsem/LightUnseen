extends Node


class_name SkillsManager

@export_group("Assignables")
@export var playerTransformer : PlayerTransformer
@export var eventsManager : EventsManager
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"
@export var skills : Array[SkillData]

@export_group("Skill Params")
@export var roll_hit_times : float
@export var slime_transform_kills_type : Vector2i
@export var slime_dash_hit_times : float
@export var slam_kills_type : Vector2i
@export var pierce_slam_amount_used : float
@export var spin_kills_type : Array[Vector2i]
@export var spit_kills_type : Array[Vector2i]

var notifier : Notifier
var carion_skills : Array[Skill]
var carion_skill_names : Array[String]
var slime_skills : Array[Skill]
var slime_skill_names : Array[String]

var created_skills : Array[Skill]
#Skills have conditions to make them available
#Each skill needs to have a script
#Much like AI States

var rock_throw : rock_throw_sk
var boulder_throw : boulder_throw_sk
var roll : roll_sk
var slime_transform : slime_transform_sk

var carion_transform : carion_transform_sk
var slime_dash : slime_dash_sk
var slime_trail : slime_trail_sk
var slam : slam_sk
var pierce : pierce_sk
var spin : mobs_defeated_sk
var spit : mobs_defeated_sk 

var abilityNode

func _ready():
	setup()

func setup():
	notifier = get_node("/root/MAIN/HUD/Node2D/Notifications")
	setup_skills()
	load_skills()
	playerTransformer.on_form_changed.connect(_add_abilities)

func load_skills():
	var loaded_carion_skills = saveManager.loaded_data["carion_skills"]
	var loaded_slime_skills = saveManager.loaded_data["slime_skills"]
	
	for skill_name in loaded_carion_skills:
		var skill = name_to_skill(skill_name)
		carion_skill_names.append(skill_name)
		if(skill != null && !carion_skills.has(skill)):
			skill.obtained = true
			skill._disable_obtain_event()
			carion_skills.append(skill)
	for skill_name in loaded_slime_skills:
		var skill = name_to_skill(skill_name)
		slime_skill_names.append(skill_name)
		if(skill != null && !slime_skills.has(skill)):
			skill.obtained = true
			skill._disable_obtain_event()
			slime_skills.append(skill)
	#_add_abilities(playerTransformer.active_form)
		
func name_to_skill(p_name):
	for skill in created_skills:
		var data = skill.skillData
		if(data.displayName == p_name):
			return skill
	return null

func setup_skill(skill : Skill,index):
	skill._setup(skills[index],eventsManager,self)
	skill.OnObtain.connect(add_ability)
	created_skills.append(skill)

func setup_skills():
	rock_throw = rock_throw_sk.new()
	boulder_throw = boulder_throw_sk.new()
	roll = roll_sk.new()
	slime_transform = slime_transform_sk.new()
	carion_transform = carion_transform_sk.new()
	slime_dash = slime_dash_sk.new()
	slime_trail = slime_trail_sk.new()
	slam = slam_sk.new()
	pierce = pierce_sk.new()
	spin = mobs_defeated_sk.new()
	spit = mobs_defeated_sk.new()
	
	boulder_throw._setup_vars(rock_throw)
	roll._setup_vars(roll_hit_times)
	slime_transform._setup_vars(slime_transform_kills_type.x,slime_transform_kills_type.y)
	carion_transform._setup_vars(slime_transform)
	slime_dash._setup_vars(slime_dash_hit_times,1,playerTransformer)
	slime_trail._setup_vars(slime_transform)
	slam._setup_vars(slam_kills_type.x,slam_kills_type.y,slime_transform)
	pierce._setup_vars(slam,pierce_slam_amount_used)
	spin._setup_vars(spin_kills_type)
	spit._setup_vars(spit_kills_type)
	
	setup_skill(rock_throw,0)
	setup_skill(boulder_throw,1)
	setup_skill(roll,2)
	setup_skill(slime_transform,3)
	setup_skill(carion_transform,4)
	setup_skill(slime_dash,5)
	setup_skill(slime_trail,6)
	setup_skill(slam,7)
	setup_skill(pierce,8)
	setup_skill(spin,9)
	setup_skill(spit,10)
	


func add_ability(skill : Skill):
	var data = skill.skillData
	eventsManager.OnSkillObtained.emit(data)
	if(notifier == null):
		notifier = get_node("/root/MAIN/HUD/Node2D/Notifications")
		
	notifier.show_skill_obtained(data)
	
	match(data.form_type):
		0:
			carion_skills.append(skill)
			carion_skill_names.append(data.displayName)
		1:
			slime_skills.append(skill)
			slime_skill_names.append(data.displayName)
		2:
			pass
			
	saveManager.add_data("carion_skills",carion_skill_names)	
	saveManager.add_data("slime_skills",slime_skill_names)	
	if(playerTransformer.current_form == data.form_type):
		abilityNode.add_ability(data)	
		
func _add_abilities(active_form):
	abilityNode = active_form.get_node("Abilities")
	var current_form = playerTransformer.current_form
	var skills = []
	match(current_form):
		0:
			skills = carion_skills
		1:
			skills = slime_skills
		2:
			pass
	for skill in skills:
		if(abilityNode.loaded):
			abilityNode.add_ability(skill.skillData)
		else:
			abilityNode.add_data(skill.skillData)
	#abilityNode._setup_abilities(skills)
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
