extends ShapeCast2D

@onready var poly : Polygon2D = $"Polygon2D"

func _physics_process(delta):
	poly.modulate.a = 0.0
	#poly.modulate = Color.AQUAMARINE if !is_colliding() else Color.RED
