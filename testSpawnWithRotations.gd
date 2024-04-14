extends Node2D

@export var template : PackedScene
@export var tileMap : TileMap
func _ready():
	var cells = tileMap.get_used_cells(0)
	for cell in cells:
		var pos = tileMap.to_global(tileMap.map_to_local(cell))
		var temp = template.instantiate() as Node2D
		temp.global_position = pos
		#var normal_scale = temp.scale
		#temp.global_transform = tileMap.global_transform
		#temp.global_position -= pos
		#temp.global_position = temp.global_position.rotated(temp.rotation)
		#temp.global_position *= sign(temp.scale)
		#temp.scale = normal_scale
		#temp.rotation_degrees *= -1.0
		add_sibling.call_deferred(temp)
		#tileMap.add_sibling(temp)
#func rotate_v2(v2:Vector2, rot : float):
	#var x_2 = cos(rot * v2.x) - sin(rot * v2.y)
	#var y_2 = sin(rot * v2.x) + cos(rot * v2.y)
	#return Vector2(x_2,y_2)
