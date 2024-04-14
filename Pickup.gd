extends Area2D

@onready var eventsManager = $"/root/MAIN/EventsManager"
@export var type : Consume.consumable
@export var animPlayer : AnimationPlayer

func setup():
	monitoring = true
	if(animPlayer != null):
		animPlayer.play("Float")

func add_consumable(body):
	var consume = body.get_node("Consume")
	consume.add_consumable(self)

func _on_pickup(body):
	if(type != Consume.consumable.NONE):
		add_consumable(body)
	queue_free()
