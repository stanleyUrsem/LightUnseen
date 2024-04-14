extends Node2D

@export var body : Node2D
@export var eyes : Node2D
@export var gradient_in : Gradient
@export var gradient_out : Gradient
@export var hsv_shift_in : Vector3
@export var hsv_shift_out : Vector3

@onready var eventsManager : EventsManager = $"/root/MAIN/EventsManager"
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"

var has_killed : bool

func _ready():
	eventsManager.OnNpcKilled.connect(set_has_killed)
	var key = "npc_amount_killed"
	if(saveManager.loaded_data.has(key)):
		var amount_killed = saveManager.loaded_data[key]
		has_killed = amount_killed > 0
		if(has_killed):
			eventsManager.OnNpcKilled.disconnect(set_has_killed)
			set_colors()
			
	
func set_has_killed(x):
	has_killed = true
	eventsManager.OnNpcKilled.disconnect(set_has_killed)
	set_colors()
	
func set_body_color():
	var gradient1d = GradientTexture1D.new()
	gradient1d.width = 18
	gradient1d.gradient = gradient_out if has_killed else gradient_in
	body.material.set_shader_parameter("palette_out",gradient1d)
func set_eyes_color():
	var hsv_shift = hsv_shift_out if has_killed else hsv_shift_in
	eyes.material.set_shader_parameter("hsv_shift",hsv_shift)
func set_colors():
	set_body_color()
	set_eyes_color()

