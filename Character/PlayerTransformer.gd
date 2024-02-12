extends Node2D

class_name PlayerTransformer

@export var forms : Array[PackedScene]
@export var saved_pos : Vector2
var current_form
var active_form


signal on_form_changed(new_player)

func _ready():
	current_form = -1
	_set_form(0)


func _set_form(index):
	if(current_form == index || index > forms.size()):
		return
	
	current_form = index
	if(active_form!= null):
		saved_pos = active_form.global_position
		active_form.queue_free()
	
	active_form = forms[current_form].instantiate()
	active_form.global_position = saved_pos
	active_form.player_transformer = self
	add_sibling.call_deferred(active_form)
	on_form_changed.emit(active_form)
