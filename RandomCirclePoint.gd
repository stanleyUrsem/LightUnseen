extends Node2D
@export var polygon : Polygon2D
@export var check_cooldown : float
@export var radius : float
var prng : PRNG
var current_cooldown : float
func _ready():
	prng = PRNG.new(1290312)

func _physics_process(delta):
	current_cooldown -= delta
	
	if(current_cooldown <= 0.0):
		current_cooldown = check_cooldown
		polygon.position = prng.random_unit_circle(false) * radius
	
	
