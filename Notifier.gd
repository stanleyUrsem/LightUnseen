extends Node

class_name Notifier
@export var notification : PackedScene
@export var gravity_up : float
@export var fade_curve : Curve
@export var duration : float

func show_skill_obtained(data):
	var note = notification.instantiate()
	add_child(note)
	#var label = note.get_node("RichTextLabel")
	
	note.setup_text("Ability obtained: %s" % data.displayName)
	
	var pos_y = note.position.y
	
	var notify_tween = get_tree().create_tween()
	notify_tween.tween_method(func(x):
		note.modulate.a = fade_curve.sample(x)
		note.position.y = lerp(pos_y,gravity_up,x),
		0.0,1.0,duration
		)
	notify_tween.tween_callback(func(): 
		queue_free()
		)
	
	
#Exclamation mark above players head, flashing
#until it stops
#and dissapears after shown once more
#Screen goes dark
#only player is visible
#all other things have stopped moving
#essentialy pause the game
#zoom in on player
#use the newly gained ability
#player animation of obtaining new skill
#Hotkey appears from player, size 0 to 1
#Text appears typed out, New skill obtained: xxxx
#Hotkey fades in at hotbar
#Text fades out
#Hotkey from player size to 0
#Screen goes back to normal
#Zoom out
#resume game
