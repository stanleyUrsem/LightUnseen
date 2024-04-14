extends Control

@export var icon : TextureRect
@export var cooldown_icon : TextureRect
@export var cooldown_regions : Array[Rect2]
@export var available   : Color
@export var unavailable : Color
var keyBinds : Array[String]
var keybind_label : RichTextLabel
var hotKeyManager : HotkeyManager
var anim : AnimationPlayer
var toggle : bool
var has_cooldown : bool
var mana : float
var index : int
var mat : Material
func setup(p_keyBinds, p_keybind_label,p_anim,p_toggle,p_mana, p_hotkeyManager,
p_index,p_mat = null,p_has_cooldown = false):
	keyBinds = p_keyBinds
	keybind_label = p_keybind_label
	anim = p_anim
	toggle = p_toggle
	index = p_index
	mat = p_mat
	icon.material = mat
	has_cooldown = p_has_cooldown
	mana = abs(p_mana)
	hotKeyManager = p_hotkeyManager

func set_keybind():
	hotKeyManager.set_keybind(keybind_label,keyBinds)

func show_cooldown(x):
	var region_index = lerp(0,cooldown_regions.size() - 1,x)
	cooldown_icon.texture.region = cooldown_regions[region_index]
	#icon.self_modulate = lerp(unavailable,available,x)
func toggle_availability(p_mana):
	if(has_cooldown):
		return
	var is_available = p_mana > mana
	var region_index = cooldown_regions.size() - 1 if is_available else 0
	
	cooldown_icon.texture.region = cooldown_regions[region_index]
	#icon.self_modulate = available if is_available else unavailable
	
func animate_toggle(x):
	hotKeyManager.on_toggle_pressed(x,anim)
