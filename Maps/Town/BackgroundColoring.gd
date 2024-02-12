extends ParallaxBackground

@export_color_no_alpha var colorA : Color
@export_color_no_alpha var colorB : Color
@export_range(0,10) var rangeLayerMin : float
@export_range(0,10) var rangeLayerMax : float


func _remap(a: float, _in: Vector2,  _out: Vector2) -> float:
	var rel = inverse_lerp(_in.x,_in.y,a)
	return lerp(_out.x,_out.y,rel)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	_getChildren(self)

func _setColor(background : Polygon2D):
	var t = _remap(background.z_index,Vector2(rangeLayerMin,rangeLayerMax),Vector2(0,1))
	
	background.color = colorA.lerp(colorB,t)
	print("Setting background color for: " , background.name , " " , t)
	_getChildren(background)


func _getChildren(node):
		for i in node.get_child_count():
			var child = node.get_child(i)
			if child is Polygon2D:
				_setColor(child)
			else:
				_getChildren(child)

