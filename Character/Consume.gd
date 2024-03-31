extends Node2D

class_name Consume

@export var stats_holder : StatsHolder
@export var hp_data : AbilityData
@export var mana_data : AbilityData
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"
var playerTransformer : PlayerTransformer
var hp_amount : int
var mana_amount : int
var hotkeyManager: HotkeyManager

var hp_cooldown : float
var mana_cooldown : float

var mana_hotkey 
var hp_hotkey
var loaded : bool
enum consumable {HP,MANA,NONE}

func _ready():
	hotkeyManager = get_node("/root/MAIN/HUD/Node2D/H/HotkeyContainer")	
	playerTransformer = get_node("/root/MAIN/PlayerTransformer")
	playerTransformer.on_form_changed.connect(set_carion_consumes)
	loaded = playerTransformer.loaded
	if(!loaded):
		hp_amount = saveManager.loaded_data["hp_amount"]
		mana_amount = saveManager.loaded_data["mana_amount"]
		setup_consumables()
	else:
		hp_amount = playerTransformer.hp_amount
		mana_amount = playerTransformer.mana_amount
		setup_consumables()
	
	
func set_carion_consumes():
	playerTransformer.hp_amount = hp_amount
	playerTransformer.mana_amount = mana_amount
	
func setup_consumables():
	
	if(hp_amount > 0):
		hp_hotkey = hotkeyManager.create_hotkey(hp_data)
		hp_hotkey.set_amount(hp_amount)
		
	if(mana_amount > 0):
		mana_hotkey = hotkeyManager.create_hotkey(mana_data)
		mana_hotkey.set_amount(mana_amount)
		
func add_consumable(drop):
	match(drop.type):
		consumable.HP:
			if(hp_amount == 0):
				hp_hotkey = hotkeyManager.create_hotkey(hp_data)
			hp_amount += 1
			saveManager.add_data("hp_amount", hp_amount)
			
			hp_hotkey.set_amount(hp_amount)
		consumable.MANA:
			if(mana_amount == 0):
				mana_hotkey = hotkeyManager.create_hotkey(mana_data)
			mana_amount += 1
			saveManager.add_data("mana_amount", hp_amount)
			
			mana_hotkey.set_amount(mana_amount)
func mana_low():
	stats_holder.stats.mana < stats_holder.stats.mana_max
func hp_low():
	stats_holder.stats.health < stats_holder.stats.health_max

func _physics_process(delta):
	consume_items()
	update_cooldown(delta)

func consume_items():
	if(Input.is_action_pressed("Consume_1") && hp_cooldown <= 0.0 &&\
		hp_low() && hp_amount > 0):
		hp_cooldown = hp_data.mana
		hp_amount -= 1
		stats_holder.add_health(hp_data.damage)
		saveManager.add_data("hp_amount", hp_amount)
	if(Input.is_action_pressed("Consume_2") && mana_cooldown <= 0.0 &&
		mana_low() && mana_amount > 0):
		mana_cooldown = mana_data.mana	
		mana_amount -= 1
		stats_holder.add_mana(mana_data.damage)
		saveManager.add_data("mana_amount", mana_amount)
		
		

func update_cooldown(delta):
	if(hp_cooldown > 0.0):
		hp_cooldown -= delta
	if(mana_cooldown > 0.0):
		mana_cooldown -= delta
	var hp_alpha = remap(hp_cooldown,hp_data.mana,0.0,0.0,1.0)
	var mp_alpha = remap(mana_cooldown,mana_data.mana,0.0,0.0,1.0)
	if(hp_hotkey != null):
		hp_hotkey.show_cooldown(hp_alpha)
	if(mana_hotkey != null):
		mana_hotkey.show_cooldown(mp_alpha)
	
