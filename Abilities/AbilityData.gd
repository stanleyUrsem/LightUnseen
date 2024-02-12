
extends "res://Abilities/SkillData.gd"
class_name AbilityData

@export var keyBinds : Array[String]

@export_file() var abilityPath : String

@export var animName : String
enum AnimationNodeType {ONESHOT,BLEND,ADD}
#@export var useOneShot : bool
@export var animNodeType : AnimationNodeType
@export var oneShot : AnimationNodeOneShot.OneShotRequest
@export var value : float

@export var animOnly : bool
@export var damage : float
@export var speed : float
@export var useMouseAim : bool
@export var toggle : bool
@export var hold : bool
@export var hold_index : int

@export var rotateToMouse : bool
#< == > 
#<= >=
#enum Conditionals {LOWER_THAN, EQUAL, BIGGER_THAN, LOWER_THAN_EQUAL, BIGGER_THAN_EQUAL}

#func _init(p_keyBind, p_displayName = "", p_description = "", p_iconPath = "",p_abilityPath = "",p_damage =0):
#func _init(p_keyBind : Array[String], p_displayName , p_description , p_iconPath,p_abilityPath ,p_damage ):
	#keyBinds = p_keyBind
	#displayName = p_displayName
	#description = p_description
	#iconPath = p_iconPath
	#damage = p_damage
	#abilityPath = p_abilityPath

