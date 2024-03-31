extends Node2D

class_name SaveManager

var save_data : Dictionary
var loaded_data : Dictionary
var new_game : bool
var index : int
func setup():
	new_game = false


func set_index(p_index : int):
	index = p_index
func swap_fullscreen_mode():
	var mode = DisplayServer.window_get_mode()
	print(mode)
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN || mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	print(DisplayServer.window_get_mode())
func _physics_process(delta):
	if(Input.is_action_just_pressed("maximize")):
		swap_fullscreen_mode()
func add_data(key,data):
	save_data[key] = data
	save_game()

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	var save_game = FileAccess.open("user://save_%d.save" % index, FileAccess.WRITE)
	
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(save_data)

	# Store the save dictionary as a new line in the save file.
	save_game.store_line(json_string)
	
func get_save_files(path):
	var save_files  = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if(file_name.contains(".save")):
					save_files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		return null
	return save_files
func erase_save(path):
	var dir = DirAccess.open("user://")
	if dir:
		var error = dir.remove(path)
		if(error != OK):
			print(error)
	else:
		print("An error occurred when trying to access the path.")
		
		
func create_empty_save():
	new_game = true
	add_data("played_scenes", [])
	add_data("carion_skills",[] )
	add_data("slime_skills",[] )
	add_data("played_prologue", false)
	add_data("hp_amount", 0)
	add_data("mana_amount", 0)
	add_data("interaction_unlocked", false)
	add_data("killed_npcs", 0)
	add_data("killed_henderson", 0)
	add_data("killed_family", 0)
	
	var save_files = get_save_files("user://")
	index = save_files.size()-1
	save_game()
	return ("user://save_%d.save" % index)
	#var prologue = get_parent().get_node("To_Prologue")
	#prologue.switch_scene()

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	
	if not FileAccess.file_exists("user://save_%d.save" % index):
		print("no save file at user://save_%d.save" % index)
		create_empty_save()
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("user://save_%d.save" % index, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()
		loaded_data = node_data
		save_data = loaded_data
		if(loaded_data["played_prologue"] == true):
			var main = get_parent().get_node("To_Main")
			main.switch_scene()
		else:
			var prologue = get_parent().get_node("To_Prologue")
			prologue.switch_scene()
			#prologue_scene.setup()
