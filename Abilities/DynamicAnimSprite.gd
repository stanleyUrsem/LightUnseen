extends "res://Abilities/DynamicSizedAction.gd"

class_name DynamicAnimSprite

@export var animSpriteTemplate : PackedScene
@export var sprites : Array[AnimatedSprite2D]
@export var animation_name : String
@export var col_parent : Node2D
@export var interval : float

var current_interval : float
var current_index : int
var fading : bool
func _on_setup():
	is_mob = true
	current_index = 0
	fading = false
	#var index = 0
	#for sprite in sprites:
		#play_next(current_index)
		#current_index += 1
	
	#for sprite in sprites:
		#index += 1
		#sprite.animation_finished.connect(func():
			#play_next(index)
			#)
	#sprites[0].play(animation_name)
	#sprites[0].animation_finished.connect(_fadeout)
	#for sprite in sprites:
		#sprite.play(animation_name)
func _physics_process(delta):
	super(delta)
	if(fading):
		return
	if(current_interval > 0):
		current_interval -= delta
	if(current_interval <= 0):
		current_interval = interval
		play_next(current_index)
		current_index += 1
		
func play_next(index):
	if(index >= sprites.size()):
		fading = true
		_fadeout()
		
		return
	sprites[index].play(animation_name)

func create_duplicate_sprite(pos):
	var animSprite = animSpriteTemplate.instantiate()
	animSprite.position = pos
	return animSprite


func _create_sprite(index,pos):
	#if(index <= 2): 
		#return
	var animSprite = create_duplicate_sprite(pos)
	add_child(animSprite)
	var collider = animSprite.get_child(0)
	collider.reparent(col_parent)
	collider.position = pos
	sprites.append(animSprite)
