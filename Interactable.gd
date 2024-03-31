extends Node2D

class_name Interactable

@export var droppable : PackedScene
@export var x_size : float
@export var path_curve_y : Curve
@export var path_curve_x : Curve
var drops : Array[Node2D]
var prng : PRNG
var drop_tween : Tween

func setup_vars(p_prng):
	prng = p_prng

func drop_item(on_drop : Callable):
	var amount = get_meta("resource_amount")
	for i in range(amount):
		var drop = droppable.instantiate()
		drop.scale = Vector2.ONE * 0.5
		drops.append(drop)
		add_child(drop)
		#add_sibling(drop)
	if(drop_tween != null):
		drop_tween.kill()
	drop_tween = get_tree().create_tween()
	drop_tween.set_parallel(true)
	for drop in drops:
		var pos = prng.random_unit_circle(false) * x_size
		drop_tween.tween_method(drop_with_position.bind(drop
		, pos)
		,0.0,1.0,0.5)
	drop_tween.set_parallel(false)
	drop_tween.tween_callback(func():
		for drop in drops:
			drop.setup()
			drop.reparent(get_parent())
			drop.scale = Vector2.ONE
			
		on_drop.call()
		)

func drop_with_position(x,drop,point):
	if(drop == null):
		return
	drop.position.x = path_curve_x.sample(x) * point.x
	drop.position.y = path_curve_y.sample(x) * point.y
	drop.rotation_degrees = lerp(0.0,360.0,x)
	print("drop pos: ",drop.position)
