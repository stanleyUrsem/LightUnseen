extends Node2D

@export var save_file_parent : Control
@export var start_menu : Control
@export var options : Control
@export var title : Control
@export var saveManager : SaveManager
@export var save_file_btn : PackedScene
@export var animPlayer : AnimationPlayer
@export var erase_save_file : Control
var highest_index = 0
var current_save_file : String
var current_button
var erasing : bool

func _ready():
	erasing = false
	options.return_button.pressed.connect(hide_options)
func show_options():
	options.visible = true
	options.mouse_filter = Control.MOUSE_FILTER_PASS
	title.visible = false
	start_menu.get_parent().visible = false
	start_menu.get_parent().mouse_filter = Control.MOUSE_FILTER_IGNORE
func hide_options():
	
	title.visible = true
	start_menu.get_parent().visible = true
	start_menu.get_parent().mouse_filter = Control.MOUSE_FILTER_PASS
	
func create_saves():
	if(save_file_parent.get_child_count() > 0):
		return
	var save_files = saveManager.get_save_files("user://")
	for save_file in save_files:
		var split = save_file.split("_")[1]
		var left = split.left(1)
		var index = int(left)
		print("found %s %d" % [save_file,index])
		if(index > highest_index):
			highest_index = index
		create_save(save_file,index)

func create_save(p_name, p_index):
	var btn = save_file_btn.instantiate()
	var full_path = p_name
	if(p_name.contains("user://")):
		p_name = p_name.right(p_name.length()-7)
		full_path = p_name
	#else:
		#full_path = "user://%s" % p_name
	
	var save_pos = p_name.length() - p_name.find("save")
	var without_suffix = p_name.left(save_pos)
	var split = without_suffix.split(".")
	var use_btn = btn.get_child(0)
	use_btn.name = split[0]
	use_btn.text = split[0]
	use_btn.pressed.connect(func():
		saveManager.set_index(p_index)
		animPlayer.play("Play")
		#saveManager.load_game()
		)
		
	var erase_btn = btn.get_child(1)
	erase_btn.pressed.connect(func():
		current_save_file = full_path
		current_button = btn
		show_erase_save_file()
		#saveManager.erase_save(full_path)
		#btn.queue_free()
		)	
	save_file_parent.add_child(btn)
	#saveManager.index = p_index + 1

func create_empty_save():
	print("Creating empty save")
	highest_index += 1
	var save_name = saveManager.create_empty_save(highest_index)
	#var index = saveManager.index
	create_save(save_name,highest_index)
func erase_save():
	if(erasing):
		return
	erasing = true
	saveManager.erase_save(current_save_file)
	current_button.queue_free()
	hide_erase_save_file()
func show_erase_save_file():
	erase_save_file.visible = true
	start_menu.visible = false
	save_file_parent.get_parent().visible = false
func hide_erase_save_file():
	erase_save_file.visible = false
	start_menu.visible = false
	save_file_parent.get_parent().visible = true
	erasing = false		
func show_save_files():
	start_menu.visible = false
	save_file_parent.get_parent().visible = true
	create_saves()
func hide_save_files():
	save_file_parent.get_parent().visible = false	
	start_menu.visible = true


