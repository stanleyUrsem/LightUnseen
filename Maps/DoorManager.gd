extends Node2D

class_name DoorManager

@export var inside_root : Node2D
@export var envo : Node2D
@export var houseTiles : TileMap
@export var houseBlack : Node2D
@export var fog : Node2D
var camZoom : CameraZoom
var zoomTween : Tween
var isMoving : bool
func _ready():
	camZoom = get_node("/root/MAIN/CameraZoom")
	isMoving = false
	
	for i in get_child_count():
		var child = get_child(i) as Area2D
		child.body_entered.connect(on_enter_house.bind(i))
		
	for i in inside_root.get_child_count():
		var child = inside_root.get_child(i).get_child(0)
		var size = child.get_layers_count()
		child.set_layer_enabled(size-1,false)
		child.set_layer_enabled(size-2,false)
		var exit = child.get_child(0) as Area2D
		exit.body_entered.connect(on_exit_house.bind(i))

func toggle_envo(toggle):
	envo.visible = toggle
	houseBlack.visible = !toggle
	fog.visible = toggle
func envo_alpha(alpha):
	envo.modulate.a = alpha
	houseBlack.modulate.a = 1.0-alpha

func cam_zoom(zooms):
	camZoom.zoom(zooms)

func on_exit_house(body, door_index):
	if(isMoving):
		return
	if(!(body is SionMovement)):
		return
	body.stopMovement = true
	isMoving =  true
	var house = inside_root.get_child(door_index).get_child(0)
	house.get_child(0).set_deferred("monitoring", false)
	house.get_child(0).set_deferred("collision_mask", 0)
	
	if(zoomTween != null):
		zoomTween.kill()
	
	zoomTween = get_tree().create_tween()
	var currentZoom = camZoom.cam.zoom.x
	#zoomTween.tween_method(cam_zoom,currentZoom,60,0.5)
	zoomTween.tween_method(func(x):
		envo_alpha(1.0-x)
		toggle_envo(true)
		
		house.modulate.a = x
		,1.0,0.0,0.5)
	zoomTween.tween_callback(func():
		house_exit(body,door_index)
		)
	zoomTween.tween_interval(0.5)
	
	#zoomTween.tween_method(cam_zoom,currentZoom,camZoom.default_zoom,0.5)
	zoomTween.tween_callback(func():
		if(body.follow_target == null):
			body.stopMovement = false
		isMoving = false
		)
	
func house_exit(body, door_index):
	var door = get_child(door_index)
	var house = inside_root.get_child(door_index).get_child(0)
	house.get_child(0).monitoring = false
	house.get_child(0).collision_mask = 0
	body.global_position = door.get_child(1).global_position
	houseTiles.set_layer_enabled(0,true)
	body.scale = Vector2.ONE
	
	var size = house.get_layers_count()
	house.set_layer_enabled(size-1,false)
	house.set_layer_enabled(size-2,false)
	body.z_index = 0
	
	house.visible = false
	door.set_deferred("collision_mask", 16)
	door.set_deferred("monitoring", true)
	
func house_enter(body, house_index):
	var house = inside_root.get_child(house_index).get_child(0)
	body.scale = Vector2.ONE 
	body.z_index = 6
	body.global_position = house.get_child(0).get_child(1).global_position
	house.get_child(0).set_deferred("monitoring", true)
	house.get_child(0).set_deferred("collision_mask", 16)
	houseTiles.set_layer_enabled(0,false)
	
	var size = house.get_layers_count()
	house.set_layer_enabled(size-1,true)
	house.set_layer_enabled(size-2,true)
	

	toggle_envo(false)
	#house.visible = true

func on_enter_house(body, house_index):
	if(isMoving):
		return
	if(!(body is SionMovement)):
		return
	body.stopMovement = true
	isMoving = true
	if(zoomTween != null):
		zoomTween.kill()
		
	var door = get_child(house_index)
	door.set_deferred("monitoring", false)
	door.set_deferred("collision_mask", 0)
	zoomTween = get_tree().create_tween()
	var currentZoom = camZoom.cam.zoom.x
	#zoomTween.tween_method(cam_zoom,currentZoom,60,0.5)
	zoomTween.tween_method(func(x):
		envo_alpha(x)
		var house = inside_root.get_child(house_index).get_child(0)
		house.modulate.a = 1.0-x
		house.visible = true
		,1.0,0.0,0.5)
	zoomTween.tween_callback(func():
		house_enter(body,house_index)
		)
	zoomTween.tween_interval(0.5)
	#zoomTween.tween_method(cam_zoom,currentZoom,currentZoom*2.0,0.5)
	zoomTween.tween_callback(func():
		body.stopMovement = false
		isMoving = false
		)
	
	



