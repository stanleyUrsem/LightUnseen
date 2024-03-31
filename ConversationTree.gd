extends Node


class_name ConversationTree

var root_node : ConversationNode
var title : String
var other_nodes : Array[ConversationNode]
var current_node : ConversationNode


func _init(begin_conv:String):
	root_node = ConversationNode.new(null,"next",begin_conv,Callable())
	current_node = root_node

func add_node(text,on_end,parent = null,option = "next"):
	if(parent == null):
		parent = root_node
	var node = ConversationNode.new(parent,option,text,on_end)
	other_nodes.append(node)
	return node

func get_skipped_node():
	while(current_node.options.size() > 1 && current_node.nodes.size() > 0):
		next_node("next")

func get_current_node():
	return current_node
	
func next_node(option:String):
	current_node = current_node.get_next_node(option)
	return current_node
