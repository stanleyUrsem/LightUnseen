extends Node2D

@export var save_file_parent : Control
@export var start_menu : Control
@export var saveManager : SaveManager
@export var save_file_btn : PackedScene
@export var animPlayer : AnimationPlayer

func create_saves():
	if(save_file_parent.get_child_count() > 0):
		return
	var save_files = saveManager.get_save_files("user://")
	for save_file in save_files:
		var index = int(save_file.split("_")[1].left(0))
		print("found %s %d" % [save_file,index])
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
		saveManager.erase_save(full_path)
		btn.queue_free()
		)	
	save_file_parent.add_child(btn)

func create_empty_save():
	print("Creating empty save")
	var save_name = saveManager.create_empty_save()
	var index = saveManager.index
	create_save(save_name,index)
	
func show_save_files():
	start_menu.visible = false
	save_file_parent.get_parent().visible = true
	create_saves()
func hide_save_files():
	save_file_parent.get_parent().visible = false	
	start_menu.visible = true
