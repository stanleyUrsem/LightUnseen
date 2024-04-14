extends SkillAction

@export var anim_player : AnimationPlayer
@export var begin : String
@export var entered : String
@export var end : String

func _ready():
	anim_player.play(begin)

func _on_body_entered(body):
	anim_player.play(entered)

func _fade(): 
	anim_player.play(end)
