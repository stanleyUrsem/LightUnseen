extends Node2D
@export var light : PointLight2D
var dayNightManager
func _ready():
	dayNightManager = get_node("/root/MAIN/DayNightManager")
	dayNightManager.OnDay.connect(toggle_light.bind(false))
	dayNightManager.OnNight.connect(toggle_light.bind(true))

func toggle_light(toggle):
	light.visible = toggle
