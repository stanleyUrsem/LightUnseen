extends Sprite2D

class_name mine_field_ground

@export var mine_template : PackedScene
@export var spawn_loc : Marker2D
@export var animationPlayer : AnimationPlayer
@export var anim : String



var data
var mouseHandler
var user
var prng
var tween : Tween

func _ready():
	if(tween != null):
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_interval(prng.range_f(0.0,1.5))
	tween.tween_callback(func():
		animationPlayer.play(anim)
		)



func setup(p_data,p_mouseHandler,p_user,p_prng):
	data = p_data
	mouseHandler = p_mouseHandler
	user = p_user
	prng = p_prng

func create_mine():
	var mine = mine_template.instantiate() as MovableAbilityaction
	var main = get_tree().root.get_child(0)
	main.add_child(mine)
	mine.setup_vars(data,mouseHandler)
	mine._setup(spawn_loc.global_position,user,Vector2.UP,prng)
	mine._setup_vars(data.speed,data.damage)
	
	
	
	
