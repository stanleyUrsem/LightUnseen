extends CameraFollow

class_name MouseHandler
@export var playerTransformer : PlayerTransformer
var mouseClickPos : Vector2
var mouseGlobalPos : Vector2
var mouseMotionPos : Vector2
func _ready():
	setup()
func setup():
	playerTransformer.on_form_changed.connect(_set_player_follow)

func _set_player_follow(player):
	position_smoothing_enabled = false
	follow_targets[0] = player
	position = player.position
	enable_smoothing.call_deferred()

func enable_smoothing():
	position_smoothing_enabled = true

func _physics_process(delta):
	if(Input.is_action_just_pressed("ui_page_up")):
		if(index + 1 >= follow_targets.size()):
			index = 0
			return
		index += 1
	if(Input.is_action_just_pressed("ui_page_down")):
		if(index - 1 < 0):
			index = follow_targets.size() - 1
			return
		index -= 1

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		mouseClickPos = event.position
		mouseGlobalPos = get_global_mouse_position()
	elif event is InputEventMouseMotion:
		mouseMotionPos =  event.position
		mouseGlobalPos = get_global_mouse_position()
		
