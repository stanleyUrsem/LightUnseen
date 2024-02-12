extends AbilityAction

@export var bubble_node : PackedScene
@export var bubbles_per_unit : float
@export var bubbles_radius : float
@export var scaleRange : Vector2
@export var pool_timer : Timer
@export var pool_scale_curve : Curve
@export var pool_particles : Array[CPUParticles2D]
@export var auto_start : bool
@export var damage_time : float
@export var colliderShape : CollisionShape2D
var created_bubbles : Array
var entered_bodies : Dictionary
var current_size:Vector2	

func _ready():
	var p_prng = PRNG.new(9091023)
	_setup(data,Vector2.ZERO,get_parent(),null,Vector2.ZERO,p_prng)

func _on_setup():
	scale = Vector2.ZERO
	current_size.x = prng.range_f_v(scaleRange)
	current_size.y = prng.range_f_v(scaleRange)
	damage_time = 1.0 /  data.speed
	scale_pool()
	pool_timer.timeout.connect(remove_pool)
	
func scale_pool():
	var scale_tween = get_tree().create_tween()
	scale_tween.tween_method(func(x):
		var clr = Color(1,1,1,x)
		scale = current_size * pool_scale_curve.sample(x)
		for particle in pool_particles:
			particle.modulate = clr
		,0.0,1.0,0.5)
	scale_tween.tween_callback(_on_pool_start)
	
func _on_pool_start():
	create_bubbles()
func remove_pool():
	var remove_tween = get_tree().create_tween()
	remove_tween.tween_method(func(x):
		var clr = Color(1,1,1,x)
		scale = current_size * pool_scale_curve.sample(x)
		for particle in pool_particles:
			particle.modulate = clr
		,1.0,0.0,0.5)
	remove_tween.tween_callback(func(): queue_free())
	
func _OnHit(collision):
	if(isHit): return
	isHit = true
func _ApplyDamage(collision):
	var hit = super(collision)
	if(hit != null && entered_bodies.has(collision)):
		entered_bodies[collision]= hit
func apply_damage_on_enter(body):
	var hit = body.get_node_or_null("Collider")
	if(hit is Hittable):
		entered_bodies[body] = hit
		hit.OnHit.emit(-damage)
		
func _physics_process(delta):
	super(delta)
	if(damage_time > 0):
		damage_time -= delta


func _process(delta):
	if(damage_time <= 0):
		for key in entered_bodies.keys():
			var value = entered_bodies[key]
			if(value != null):
				value.OnHit.emit(-damage)
		damage_time =  1.0 /  data.speed	

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
		bubble.position = prng.random_unit_circle(true) * scale * bubbles_radius
		bubble.setup(prng)
