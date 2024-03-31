extends Node2D

@export var gradients : Array[Gradient]
@export var sprite : Sprite2D
@export var mat : Material
var prng
func _ready():
	prng = PRNG.new(1293123)
	var newTex = GradientTexture1D.new()
	newTex.width = 18
	newTex.gradient = prng.random_element(gradients)
	newTex.use_hdr = false
	
	var duped_mat = mat.duplicate(true)
	
	duped_mat.set_shader_parameter("palette_out",newTex)
	sprite.material = duped_mat
