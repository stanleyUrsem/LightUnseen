extends Node

class_name ConversationHolder
@export var area : Area2D
@export var dialogue_symbol : Control
@export var scale_curve : Curve

var eventsManager : EventsManager
var convoManager : ConversationManager
var tween : Tween
var convo_trees : Array[ConversationTree]
func _ready():
	eventsManager = get_node("/root/MAIN/EventsManager") as EventsManager
	convoManager = get_node("/root/MAIN/HUD/Node2D/Convo")
	area.body_entered.connect(_on_enter)
	


func start_convo():
	convoManager.open_dialogue(convo_trees)
	
func _on_enter(body):
	if(tween != null):
		tween.kill()
	
	if(!body.talkable_npcs.has(self)):
		body.talkable_npcs.append(self)
	
	tween = get_tree().create_tween()
	
	
	tween.tween_method(func(x):
		dialogue_symbol.scale.x = scale_curve.sample(x)
		dialogue_symbol.scale.y = scale_curve.sample(x)
		,0.0,1.0,0.5)
func _on_exit(body):
	if(tween != null):
		tween.kill()
		
	if(body.talkable_npcs.has(self)):
		body.talkable_npcs.erase(self)
	tween = get_tree().create_tween()
	
	tween.tween_method(func(x):
		dialogue_symbol.scale.x = scale_curve.sample(x)
		dialogue_symbol.scale.y = scale_curve.sample(x)
		,1.0,0.0,0.5)
