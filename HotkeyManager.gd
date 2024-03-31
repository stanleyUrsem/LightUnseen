extends Control

class_name HotkeyManager
@export var hotkey_size : int
@export var manaManager : ManaManager
@export var regular_hotkey : PackedScene
@export var slime_hotkey : PackedScene
@export var animated_slime_hotkey : PackedScene
@export var consumable_hotkey : PackedScene

var controller_activated : bool
var toggles : Dictionary
var hotkeys : Array
signal anything_pressed
signal toggle_pressed(ability_name)
signal switched_setup()
var hBox : HBoxContainer
var keybindTranslator : ControllerKeybindsTranslator

func _ready():
	setup()

func setup():
	#hBox = get_parent()
	keybindTranslator = ControllerKeybindsTranslator.new()
	manaManager.value_changed.connect(set_hotkey_availability)
	#hBox.size.y = hotkey_size
	#hBox.offset_top = -hotkey_size
	#hBox.offset_left = 0
	#hBox.offset_right = 0
	#hBox.offset_bottom = 0
	
func set_hotkey_availability(mana):
	for hotkey in hotkeys:
		hotkey.toggle_availability(mana)
func get_hotkey_scene(form_type : AbilityData.form_enum, toggle):
	print("FORM TYPE: ",form_type)
	match(form_type):
		AbilityData.form_enum.Carion:
			return regular_hotkey
		AbilityData.form_enum.Slime:
			if(toggle):
				return animated_slime_hotkey
			else:
				return slime_hotkey
		AbilityData.form_enum.CrystalGolem:
			pass
		AbilityData.form_enum.Consumable:
			return consumable_hotkey 
			
func destroy_current_hotkeys():
	for hotkey in hotkeys:
		switched_setup.disconnect(hotkey.set_keybind)
		if(hotkey.toggle):
			toggle_pressed.disconnect(hotkey.animate_toggle)
		hotkey.queue_free()
	hotkeys.clear()
		
func create_hotkey(data : AbilityData):
	var hotkey = get_hotkey_scene(data.form_type,data.toggle).instantiate()
	var icon : TextureRect = hotkey.get_node("Background/Icon")
	var keybind : RichTextLabel = hotkey.get_node("Background/H/V/Keybind")
	var anim: AnimationPlayer = hotkey.get_node_or_null("AnimationPlayer")
	hotkey.custom_minimum_size = Vector2(hotkey_size,hotkey_size)
	hotkey.setup(data.keyBinds,keybind,anim,data.toggle,
	data.mana,self,data.hotkey_index)
	hotkey.tooltip_text = data.displayName
	var atlas :AtlasTexture= AtlasTexture.new()
	atlas.atlas = data.icon.atlas
	atlas.margin = data.icon.margin
	atlas.region = data.icon.region
	icon.texture = atlas
	set_keybind(keybind,data.keyBinds)
	switched_setup.connect(hotkey.set_keybind)
	if(data.toggle):
		print("%s IS A TOGGLE" % data.displayName)
		setup_toggle(data.displayName)
		toggle_pressed.connect(hotkey.animate_toggle)
	hotkeys.append(hotkey)
	#
	#if(hotkeys.size() > columns):
		#var roundedAmount = ceilf(float(hotkeys.size()) / columns)
		#hBox.size.y = roundedAmount * hotkey_size
		#hBox.offset_top = -roundedAmount * hotkey_size
		#hBox.offset_left = 0
		#hBox.offset_right = 0
		#hBox.offset_bottom = 0
	add_child(hotkey)
	#if(data.hotkey_index >= 0):
	
		#move_child(hotkey,data.hotkey_index)
	set_hotkeys_index()
	return hotkey

func set_hotkeys_index():
	var end_index = hotkeys.size()
	for hotkey in hotkeys:
		var index = hotkey.index
		if(hotkey.index >= end_index):
			index = end_index - 1
		move_child(hotkey,index)

func on_toggle_pressed(ability_name,anim):
	if(toggles[ability_name] == true):
		toggles[ability_name] = false
		anim.play("Toggle_Off")
	else:
		toggles[ability_name] = true
		anim.play("Toggle_On")
		

func setup_toggle(ability_name):
	toggles[ability_name] = false

func get_keybind_text(index,keybinds) -> String:
	var text = ""
	for i in keybinds.size():
		var keybind = keybinds[i]
		if(i > 0):
			text += "+"
		var keybind_text = InputMap.action_get_events(keybind)[index].as_text()
		print("text nil: ", text == null)
		text = text + keybindTranslator.translate_keybind(keybind_text)
	
	return text

func set_keybind(keybind_label:RichTextLabel,keybinds:Array[String]):
	if(controller_activated):
		keybind_label.text = get_keybind_text(1,keybinds)
	else:
		keybind_label.text = get_keybind_text(0,keybinds)
		


func _input(event):
	var switched = false
	#match(event):
	if(event is InputEventMouseButton || 
	event is InputEventMouseMotion || event is InputEventKey):
		if(controller_activated):
			switched = true
		controller_activated = false
		if(!(event is InputEventMouseMotion)):
			anything_pressed.emit()
			
	if(event is	InputEventJoypadButton):
		if(!controller_activated):
			switched = true
		controller_activated = true
		anything_pressed.emit()
			
			
	if(event is	InputEventJoypadMotion):
		if(event.axis_value > 0.5 || event.axis_value < -0.5):
			if(!controller_activated):
				switched = true
			controller_activated = true
		anything_pressed.emit()
				
	if(switched):
		print("Controller activated: ", controller_activated)
		switched_setup.emit()
