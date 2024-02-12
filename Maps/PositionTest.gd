extends TileMap

@export var layer_index: int

var emptyPoly

func _ready():
	emptyPoly = preload("res://Maps/Crystal.tscn")
	if(layer_index <0):
		return
	var tiles = get_used_cells(layer_index)
	for i in tiles.size():
		var pos  = to_global(map_to_local(tiles[i]))
		create_empty(i,pos)


func create_empty(index,pos):
	var empty = emptyPoly.instantiate()
	empty.name = str("Empty %d" % index)
	get_parent().add_child.call_deferred(empty)
	empty.position = pos
