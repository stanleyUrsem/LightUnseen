extends "res://Pickup.gd"

func _on_pickup(body):
	eventsManager.OnPickUpStone.emit()
	super(body)


