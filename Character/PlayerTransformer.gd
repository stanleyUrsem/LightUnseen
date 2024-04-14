extends Node2D

class_name PlayerTransformer

@export var mapSwitcher : MapSwitcher
@export var forms : Array[PackedScene]
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"
var doorManager : DoorManager
var eventsManager : EventsManager
var current_form
var active_form
var saved_pos : Vector2
var hp_amount : int
var mana_amount : int
var loaded : bool
var hp_on_transform : float
var mana_on_transform : float


signal on_form_changed(new_player)

func _ready():
	hp_on_transform = -1
	mana_on_transform = -1
	hp_amount = saveManager.loaded_data["hp_amount"]
	mana_amount = saveManager.loaded_data["mana_amount"]
	mapSwitcher.OnMapLoaded.connect(setup)
	#setup()

func setup():	
	doorManager = get_node("/root/MAIN/Central/Doors")
	current_form = -1
	_set_form(0)
	doorManager.on_enter_house(active_form,2)
	loaded = true

func _set_form(index):
	if(current_form == index || index > forms.size()):
		return
	
	current_form = index
	if(active_form!= null):
		saved_pos = active_form.global_position
		var holder = active_form.get_node("Stats")
		mana_on_transform = holder.stats.mana
		hp_on_transform = holder.stats.health
		active_form.queue_free()
	
	active_form = forms[current_form].instantiate()
	var holder = active_form.get_node("Stats")
	holder.setup_mana_hp(mana_on_transform,hp_on_transform)
	active_form.global_position = saved_pos
	active_form.player_transformer = self
	add_sibling.call_deferred(active_form)
	on_form_changed.emit(active_form)
