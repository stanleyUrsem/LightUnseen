extends Control

class_name ConversationManager



@export var convo : RichTextLabel
@export var txt_speed : float
@export var options : Array[Button]
@export var convo_trees : Array[RichTextLabel]
@export var next : Button
@export var skip : Button
@export var offset_bot_range : Vector2

var active_tree : ConversationTree
var current_node : ConversationNode
var convo_tween : Tween
var trees : Array[ConversationTree]
var dialogue_tween : Tween
func _ready():
	setup()
func setup():
	for option in options:
		option.pressed.connect(next_node.bind(option))
	next.pressed.connect(next_node.bind(next))
	skip.pressed.connect(skip_node.bind(skip))
	
	for i in convo_trees.size():
		var tree = convo_trees[i]
		tree.meta_clicked.connect(choose_tree.bind(i))

func choose_tree(meta, index : int):
	for i in convo_trees.size():
		var tree = convo_trees[i]
		tree.visible = i == index
	active_tree = trees[index]
	current_node = active_tree.next_node("next")
	animate_convo_text()


func open_dialogue(p_trees):
	if(dialogue_tween != null):
		dialogue_tween.kill()
		
	dialogue_tween = get_tree().create_tween()
	dialogue_tween.tween_method(func(x):
		offset_bottom = lerp(offset_bot_range.x,offset_bot_range.y,x),
		0.0,1.0,0.75
		)
	dialogue_tween.tween_callback(func():
		for i in p_trees.size():
			convo_trees[i].visible = true
		
		)	
	
		


	
func close_dialogue():
	for tree in convo_trees:
		tree.visible = false
	
	if(dialogue_tween != null):
		dialogue_tween.kill()
		
	dialogue_tween = get_tree().create_tween()
	dialogue_tween.tween_method(func(x):
		offset_bottom = lerp(offset_bot_range.x,offset_bot_range.y,x),
		1.0,0.0,0.75
		)	
	
	

	
func next_node(btn:Button):
	current_node = active_tree.next_node(btn.text)
	disable_options()
	animate_convo_text()
	
func skip_node(btn:Button):
	current_node = active_tree.get_skipped_node()
	disable_options()
	animate_convo_text()	
	
func animate_convo_text():
	if(convo_tween != null):
		convo_tween.kill()
	convo_tween = get_tree().create_tween()
	var duration = current_node.text.length()/txt_speed
	convo_tween.tween_method(set_convo_text,0.0,1.0,duration)
	convo_tween.tween_callback(activate_options)
	
func set_convo_text(progress:float):
	var size = floor(current_node.text.length() * progress)
	var txt = current_node.text.left(size)
	convo.text = txt
	
func disable_options():
	for option in options:
		option.disabled = true
		
func activate_options():
	current_node.end()
	for i in current_node.options.size():
		var option = options[i]
		option.disabled = false
		var option_txt = current_node.options[i]	
		option.text = option_txt
	
	
	
	
