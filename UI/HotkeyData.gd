extends AspectRatioContainer

var keyBinds : Array[String]
var keybind_label : RichTextLabel
var hotKeyManager : HotkeyManager
var anim : AnimationPlayer
var toggle : bool
func setup(p_keyBinds, p_keybind_label,p_anim,p_toggle, p_hotkeyManager):
	keyBinds = p_keyBinds
	keybind_label = p_keybind_label
	anim = p_anim
	toggle = p_toggle
	hotKeyManager = p_hotkeyManager

func set_keybind():
	hotKeyManager.set_keybind(keybind_label,keyBinds)
	
func animate_toggle(x):
	hotKeyManager.on_toggle_pressed(x,anim)
