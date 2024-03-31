extends Node2D

@export var hit_number_scene : PackedScene
var prng

func _ready():
	setup()

func setup():
	prng = PRNG.new(19231)

func onHit(pos,damage,is_mob):
	var hitNumber = hit_number_scene.instantiate()
	add_child(hitNumber)
	hitNumber._setup(pos,damage,is_mob,prng)
