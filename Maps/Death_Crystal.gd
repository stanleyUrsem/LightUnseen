extends "res://Maps/CrystalPickup.gd"

func setup_vars(p_prng):
	prng = p_prng
	OnPickUp.connect(erase_tile)

		
func erase_tile(tile,on_erased, duration):
	var sprite = tile.get_child(0) as Sprite2D
	var collider = tile.get_child(1) as CollisionShape2D
	var respawn_tween = get_tree().create_tween() as Tween
	collider.disabled = true
	
	respawn_tween.tween_method(func(x):
		var clr = Color(1,1,1,x)
		sprite.modulate = clr
		,1.0,0.0,0.5)
	respawn_tween.tween_callback(func():
		on_erased.call()
		)	
