extends AudioStreamPlayer
@export var min_vol : float
func _ready():
	volume_db = min_vol
