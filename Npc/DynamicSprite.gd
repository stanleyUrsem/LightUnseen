extends "res://Abilities/DynamicSizedAction.gd"
@export var animSpriteTemplate : PackedScene
@export var col_parent : Node2D
@export var sprites : Array[AnimatedSprite2D]
@export var begin_anim : String
@export var anim_player : AnimationPlayer
@onready var audio_stream : AudioStreamPlayer2D = $"AudioStreamPlayer2D"

func play_anim_sprite(anim_name : String):
	for sprite in sprites:
		sprite.play(anim_name)	
func _on_setup():
	super()
	var middle_sprite = sprites[sprites.size()/2.0]
	audio_stream.position = middle_sprite.position
	if(anim_player != null):
		anim_player.play(begin_anim)
	
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
