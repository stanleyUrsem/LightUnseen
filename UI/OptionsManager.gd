extends Control

@onready var options : Control = $"/root/MAIN/HUD/Node2D/Options"
@onready var quit_btn : Control = $"/root/MAIN/HUD/Node2D/Quit"
@onready var player_transformer : PlayerTransformer = $"/root/MAIN/PlayerTransformer"
var options_active : bool = false
var abilities : AbilityManager
func _ready():
	player_transformer.on_form_changed.connect(set_abilities)
	options.return_button.pressed.connect(set_abilities_enabled)
	
func set_abilities_enabled():
	options_active = !options_active
	abilities.set_enabled(!options_active)
	

func set_abilities(p_player):
	abilities = p_player.get_node("Abilities")
func _physics_process(delta):
	pause_resume()

func pause_resume():
	if(Input.is_action_just_pressed("pause")):
		options_active = !options_active
		options.visible = options_active
		quit_btn.visible = options_active
		var filter = Control.MOUSE_FILTER_PASS if options_active else Control.MOUSE_FILTER_STOP
		options.mouse_filter = filter
		quit_btn.mouse_filter = filter
		abilities.set_enabled(!options_active)
