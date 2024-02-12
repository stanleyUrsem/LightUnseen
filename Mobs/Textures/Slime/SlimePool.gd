extends Node2D

@export_file() var bubble_path : String
#@export_file() var slime_edge : String
@export_file() var slime_area_path : String
@export var max_expand : float
@export var expand_duration : float
@export var expand_increase : float
@export var bubbles_per_unit : int
@export var bubbles_circle : float
@export var slime_area : Sprite2D

var current_expand
var expand_tween : Tween
var expanding
var bubble_node
#var slime_edge_node
var area_texture
var created_bubbles : Array[Sprite2D]
var saved_size
var current_size
var prng : PRNG

func _ready():
	prng = PRNG.new(129)
	current_expand = 1.0
	bubble_node = load(bubble_path)
	#slime_edge_node = load(slime_edge)
	area_texture = load(slime_area_path)
	saved_size = Vector2( area_texture.width * prng.range_f(1.1,1.25),area_texture.height* prng.range_f(1.1,1.25))
	current_size = saved_size
	set_gradient_size(slime_area,current_size)
	expanding = true
#	create_bubbles(1.0)
#	expand_tween = get_tree().create_tween()
#	expand_tween.set_loops()
#	expand_tween.tween_method(expand,0.0,1.0,expand_duration)
#	expand_tween.tween_callback(
#		func(): current_expand += expand_increase)
#	expand_tween.loop_finished.connect(create_bubbles)

func expand():
	if(expand_tween!= null && expand_tween.is_running()):
		current_expand += expand_increase
		expand_tween.kill()
	
	create_bubbles(1.0)
	expand_tween = get_tree().create_tween()
	expand_tween.tween_method(expand,0.0,1.0,expand_duration)
	expand_tween.tween_callback(
		func(): 
			current_expand += expand_increase
			create_bubbles(1.0))

func create_bubbles(sig):
	print("creating bubbles")
	var amount_bubbles = bubbles_per_unit * current_size
	print("amount: ", amount_bubbles)
	print("size: ", current_size)
	while(created_bubbles.size() < amount_bubbles):
		var bubble = bubble_node.instantiate()
		add_child(bubble)
		created_bubbles.append(bubble)
	
	for i in created_bubbles.size():
		var bubble = created_bubbles[i]
		bubble.position = prng.random_unit_circle(true) * current_size * bubbles_circle
		bubble.setup(prng)
	

func expand_over_time(value):
	var val = lerp(current_expand,current_expand + expand_increase,value)
#	slime_area.scale = Vector2.ONE * val
	current_size = Vector2i(saved_size*val)
	set_gradient_size(slime_area,current_size)
	if(current_expand >= max_expand):
#		set_gradient_size(slime_area,current_size)
#		expanding = false
		expand_tween.kill()
#		expand_increase *= -1.0
#	if(!expanding && current_expand <= 1.0):

func set_gradient_size(node:Sprite2D,value):
	area_texture.set_width(value.x)
	area_texture.set_height(value.y)
#	var image : Image= area_texture.get_image()
#	image.resize(value,value,Image.INTERPOLATE_NEAREST)
#	node.texture = ImageTexture.create_from_image(image)
