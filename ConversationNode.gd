extends Node


class_name ConversationNode

var text : String
var options : Array[String]
var nodes : Dictionary
var parentState
var option : String
var on_end : Callable
func _init(p_parentState, p_option, p_text, p_on_end):
	on_end = p_on_end
	parentState = p_parentState
	option = p_option
	text = p_text
	if(parentState != null):
		parentState.add_node(self, option)

func add_node(node: ConversationNode,option = ""):
	if(option == ""):
		return
	nodes[option] = node

func end():
	if(on_end.is_null()):
		return
	
	on_end.call()
	
func get_next_node(option:String):
	if(nodes.size() <= 0):
		return null
	if(nodes.has(option)):
		return nodes[option]
