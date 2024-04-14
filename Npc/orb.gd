extends SkillAction

@export var pool : PackedScene
@export var spawn_point_root : Node2D
@export var scale_increase_range : Vector2
@export var damage_time : float
@export var animTree : AnimationTree

var current_scale : float
var current_damage_time : float
var active_body 
var created_pools : Array
var current_pool 
var spawn_points : Array[Vector2]
var current_index
func _on_setup():
	current_index = 0
	for point in spawn_point_root.get_children():
		spawn_points.append(point.position)
	create_pool()

func create_pool():
	var created_pool = pool.instantiate() as Area2D
	created_pool.position = spawn_points[current_index]
	created_pool.body_entered.connect(on_pool_enter)
	created_pool.body_exited.connect(on_pool_exit)
	created_pools.append(created_pool)
	current_pool = created_pool
	add_child(created_pool)
	
func increase_scale():
	if(current_index > spawn_points.size() - 1):
		return
	current_scale += prng.range_f(scale_increase_range.x,
	scale_increase_range.y)
	#var pool_scale = float(created_pools.size()) - current_scale
	#if(pool_scale < 0.0):
		#if(current_pool != null):
			#current_pool.scale = Vector2.ONE
		#create_pool()
		#current_index+=1
	if(current_scale > 1.0):
		current_pool.scale = Vector2.ONE
		current_scale -= 1.0
		create_pool()
		current_index += 1
		if(current_index > spawn_points.size() - 1):
			AnimatorHelper._playanimTreeBlend2D(animTree,"Throw",1.0)
			#_fadeout()
			return
		 
	current_pool.scale = Vector2.ONE * current_scale
	#created.pool.size - current_scale>0
	#0 - 0.5 = -0.5
	#1 - 0.75 = 0.25
	#1 - 1.25 = -0.25

func on_pool_enter(body):
	current_damage_time = damage_time
	active_body = body
	_ApplyDamage(body,true)
func on_pool_exit(x):
	active_body = null
		
func _physics_process(delta):
	super(delta)
	if(active_body == null):
		return
	current_damage_time -= delta
	if(current_damage_time <= 0):
		current_damage_time = damage_time
		_ApplyDamage(active_body,true)
