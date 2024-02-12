extends Node2D


#const LightTexture = preload("res://Maps/Town/light_.tres")
#const WindyMat = preload("res://Maps/Town/windy.tres")
const GRID_SIZE = 4

@onready var fog = $Fog
@export var targets : Array[Node2D]
@export var tileMap  : TileMap
@export var display_width  : float
@export var display_height : float
@export var track_offset : Vector2
@export var track_scale : Vector2
@export var add_local_pos : bool
var fogImage = Image.new()
var fogTexture = ImageTexture.new()
#var lightImage = LightTexture.get_image()
#var light_offset = Vector2(LightTexture.get_width(), LightTexture.get_height())
var light_rect
var grid_pos
var unit_pos
var mouse_pos

var grad_e1
var grad_e2
var grad_e3
var grad_e4


func setup_images():
	var grad_texture = preload("res://Maps/Town/new_gradient2.tres")
	var grad_image = grad_texture.get_image() as Image
	grad_e1 = grad_image.get_region(Rect2i(0,0,16,16))
	grad_e2 = grad_image.get_region(Rect2i(0,16,16,16))
	grad_e3 = grad_image.get_region(Rect2i(0,32,16,16))
	grad_e4 = grad_image.get_region(Rect2i(0,48,16,16))

func _ready():
	var fog_image_width = display_width/GRID_SIZE
	var fog_image_height = display_height/GRID_SIZE
	fogImage = Image.create(fog_image_width,fog_image_height,false,Image.FORMAT_RGBAH)
	fogImage.fill(Color.BLACK)
#	lightImage.convert(Image.FORMAT_RGBAH)
	fog.scale *= GRID_SIZE
	
func update_fog(new_grid_position, light_rect, lightImage, light_offset):
#	fogImage.lock()
#	lightImage.lock()
	grid_pos = new_grid_position
	light_rect = Rect2(Vector2.ZERO, Vector2(lightImage.get_width()*track_scale.x,
	lightImage.get_height()*track_scale.y))
	var pos = new_grid_position
	var rect_offset = Vector2(lightImage.get_width()*(1.0-track_scale.x),
	lightImage.get_height()*(1.0-track_scale.y))
	if(add_local_pos):
		pos -= (light_offset*track_offset)
		pos += rect_offset/2.0
	fogImage.blend_rect(lightImage, light_rect,pos)
	
#	fogImage.unlock()
#	lightImage.unlock()
	update_fog_image_texture()

	
func update_fog_image_texture():
	fogTexture = ImageTexture.create_from_image(fogImage)
#	WindyMat.set_shader_parameter("sample_texture",fogTexture)
	fog.texture = fogTexture

#func _input(event):
#	mouse_pos = fog.get_local_mouse_position()
#	if(add_local_pos):
#		pos+= to_local(fog.position)
	
#	update_fog(mouse_pos/GRID_SIZE)
	
#func _process(delta):
#	for i in targets.size():
##		var local_pos =
#		var display = Vector2(display_width,display_height)
#		var size = Vector2(lightImage.get_width(),lightImage.get_height())
#		display -= size * GRID_SIZE
#		display *= 0.5
#		unit_pos = to_local((targets[i].position+display))
#		update_fog_local(unit_pos)
#
#func update_fog_local(local_pos):
#	update_fog(local_pos/GRID_SIZE)
