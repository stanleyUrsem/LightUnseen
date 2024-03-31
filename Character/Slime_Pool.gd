extends AbilityAction

@export var bubble_node : PackedScene
@export var bubbles_per_unit : float
@export var bubbles_radius : float
@export var scaleRange : Vector2
@export var textureScale : Vector2
@export var pool_timer : Timer
@export var pool_scale_curve : Curve
@export var pool_sprites : Array[Sprite2D]
@export var outer_pool : Node2D
@export var auto_start : bool
@export var damage_time : float
@export var colliderShape : CollisionShape2D
@export var outerCollider : CollisionShape2D
var created_bubbles : Array
var entered_bodies : Dictionary
var current_size:Vector2	


func _on_setup():
	super()
	scale = Vector2.ZERO
	current_size.x = prng.range_f_v(scaleRange)
	current_size.y = prng.range_f_v(scaleRange)
	damage_time = data.speed
	outer_pool.position = prng.random_unit_circle(true) * current_size * bubbles_radius
	outerCollider.position = outer_pool.position
	scale_pool()
	pool_timer.timeout.connect(remove_pool)
func _fade():
	return
func scale_pool():
	var scale_tween = get_tree().create_tween()
	scale_tween.tween_method(set_pool,0.0,1.0,0.5)
	scale_tween.tween_callback(func():
		create_bubbles()
		outerCollider.scale = current_size	
		)
func set_pool(x : float):
	#var clr = Color(1,1,1,x)
	scale = current_size * pool_scale_curve.sample(x)
	#for sprite in pool_sprites:
		#sprite.modulate = clr

func free_pool():
	queue_free()
func remove_pool():
	var remove_tween = get_tree().create_tween()
	remove_tween.tween_method(set_pool,1.0,0.0,0.5)
	remove_tween.tween_callback(free_pool)
	

func _ApplyDamage(collision,is_cast = false):
	var hit = super(collision,is_cast)
	if(hit != null && entered_bodies.has(collision)):
		entered_bodies[collision]= hit
func apply_damage_on_enter(body):
	var hit = body.get_node_or_null("Hittable")
	if(hit is Hittable):
		entered_bodies[body] = hit
		hit.OnHit.emit(damage,user)
		
func _physics_process(delta):
	super(delta)
	if(damage_time > 0):
		damage_time -= delta


func _process(delta):
	if(damage_time <= 0):
		for key in entered_bodies.keys():
			var value = entered_bodies[key]
			if(value != null):
				value.OnHit.emit(damage,user)
		damage_time = data.speed	

func on_exit(body):
	entered_bodies.erase(body)

func create_bubbles():
	#print("creating bubbles")
	var amount_bubbles = bubbles_per_unit * (scale.x+scale.y)
	#print("amount: ", amount_bubbles)
	#print("size: ", current_size)
	while(created_bubbles.size() < amount_bubbles):
		var bubble = bubble_node.instantiate()
		add_child(bubble)
		created_bubbles.append(bubble)
	
	for i in created_bubbles.size():
		var bubble = created_bubbles[i]
		var offset = prng.random_unit_circle(true) * textureScale * scale * bubbles_radius
		bubble.position = offset
		bubble.setup(prng)
