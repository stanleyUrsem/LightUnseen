extends "res://Pickup.gd"
@export var door : Area2D
@onready var saveManager : SaveManager = $"/root/MAIN/SaveManager"

func _ready():
	var unlocked = saveManager.loaded_data["interaction_unlocked"]
	if(unlocked):
		queue_free()

func _on_pickup(body):
	eventsManager.OnToolsPickUp.emit()
	door.monitoring = true
	super(body)
