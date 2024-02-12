extends CameraFollow

class_name MouseHandler
@export var playerTransformer : PlayerTransformer
var mouseClickPos : Vector2
var mouseGlobalPos : Vector2
var mouseMotionPos : Vector2

func _ready():
	playerTransformer.on_form_changed.connect(_set_player_follow)

func _set_player_follow(player):
	follow_targets[0] = player

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		mouseClickPos = event.position
		mouseGlobalPos = get_global_mouse_position()
	elif event is InputEventMouseMotion:
		mouseMotionPos =  event.position
		mouseGlobalPos = get_global_mouse_position()
		
