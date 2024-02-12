extends Node2D

class_name CameraZoom

@onready var cam = $/root/MAIN/Camera2D

func zoom(value):
	cam.zoom = Vector2.ONE * value
