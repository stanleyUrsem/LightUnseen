extends Camera2D

@export var leftpoint: Node2D
@export var rightpoint: Node2D

func _ready():
	self.limit_left = leftpoint.transform.get_origin().x
	self.limit_right = rightpoint.transform.get_origin().x;
	
