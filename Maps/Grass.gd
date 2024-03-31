extends Interactable
var entered : bool
var sprite
var short_frame
var long_frame
signal OnPickUp(sprite,on_erased, duration)

func setup(offset,frame):
	sprite = get_node("TileSprite") as Sprite2D
	sprite.material = sprite.material.duplicate()
	sprite.material.set_shader_parameter("offset", offset)
	sprite.frame = frame
	long_frame = frame
	short_frame = frame - 4
	entered = false

func _on_grass_entered(area):
	if(!entered):
		sprite.frame = short_frame
		sprite.z_index = 3
		sprite.material.set_shader_parameter("player_near", 1.0)
		entered = true

func _on_grass_exited(area):
	if(!entered):
		return
	
	var exit_tween = get_tree().create_tween()
#	exit_tween.tween_method(set_player_near,0.0,1.0,0.5)
	exit_tween.tween_interval(0.5)
	exit_tween.tween_callback(
		func(): 
			set_player_near(0.0)
			sprite.frame = long_frame
			sprite.z_index = 0
			entered = false)
	
func set_player_near(value):
	sprite.material.set_shader_parameter("player_near", value)
