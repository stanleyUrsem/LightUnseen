extends Node

class_name Notifier
@export var notification : PackedScene
@export var gravity_up : float
@export var fade_curve : Curve
@export var letter_curve : Curve
@export var duration : float

func show_skill_obtained(data):
	var note = notification.instantiate()
	add_child(note)
	#var label = note.get_node("RichTextLabel")
	
	note.setup_text("Ability obtained: %s" % data.displayName)
	note.setup_icon(data.icon)
	var pos_y = note.position.y
	var text = "Ability obtained: %s" % data.displayName as String
	var notify_tween = get_tree().create_tween()
	notify_tween.tween_method(func(x):
		var amount_letters = lerp(0,text.length(),letter_curve.sample(x))
		note.setup_text(text.left(amount_letters))
		note.modulate.a = fade_curve.sample(x)
		note.position.y = lerp(pos_y,gravity_up,x),
		0.0,1.5,duration
		)
	notify_tween.tween_callback(func(): 
		note.queue_free()
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
