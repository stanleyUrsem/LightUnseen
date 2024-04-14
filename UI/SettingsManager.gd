extends Control
@export var return_button : Button
@export_group("Sound")
@export var audio : AudioBusLayout
@export var main_volume : Range
@export var main_volume_range : Vector2
@export var music_volume : Range
@export var music_volume_range : Vector2
@export var sfx_volume : Range
@export var sfx_volume_range : Vector2

@export_group("Graphics")
@export var envo : Environment
@export var brightness : Range
@export var contrast : Range
@export var saturation : Range
@export var bloom : CheckBox

@export_group("Display")
@export var fullscreen : CheckBox

var settings_data : Dictionary
var loaded_data : Dictionary


func _ready():
	setup()
	load_settings()
	apply_loaded_settings()
	return_button.pressed.connect(hide_self)
func hide_self():
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_settings()

func swap_fullscreen_mode():
	var mode = DisplayServer.window_get_mode()
	print(mode)
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN || mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	print(DisplayServer.window_get_mode())
func setup():
	main_volume.value_changed.connect(set_main_volume)
	music_volume.value_changed.connect(set_music_volume)
	sfx_volume.value_changed.connect(set_sfx_volume)
	
	brightness.value_changed.connect(set_brightness)
	contrast.value_changed.connect(set_contrast)
	saturation.value_changed.connect(set_saturation)
	
	bloom.toggled.connect(set_bloom)
	fullscreen.toggled.connect(set_full_screen)
	
func apply_loaded_settings():
	main_volume.value = remap(loaded_data["main_volume"],
	main_volume_range.x,main_volume_range.y,0.0,100.0)
	
	music_volume.value = remap(loaded_data["music_volume"],
	music_volume_range.x,music_volume_range.y,0.0,100.0)
	
	sfx_volume.value = remap(loaded_data["sfx_volume"],
	sfx_volume_range.x,sfx_volume_range.y,0.0,100.0)
	
	brightness.value = loaded_data["brightness"]
	contrast.value = loaded_data["contrast"]
	saturation.value = loaded_data["saturation"]
	
	bloom.button_pressed = loaded_data["bloom"]
	fullscreen.button_pressed = loaded_data["full_screen"]

func set_main_volume(db : float):
	db = remap(db,0,100.0,main_volume_range.x,main_volume_range.y)
	AudioServer.set_bus_volume_db(0,db)
	add_data("main_volume",db)
func set_music_volume(db: float):
	db = remap(db,0,100.0,music_volume_range.x,music_volume_range.y)
	AudioServer.set_bus_volume_db(1,db)
	add_data("music_volume",db)
	
func set_sfx_volume(db: float):
	db = remap(db,0,100.0,sfx_volume_range.x,sfx_volume_range.y)
	
	AudioServer.set_bus_volume_db(2,db)
	add_data("sfx_volume",db)

func set_brightness(value: float):
	envo.adjustment_brightness = value
	add_data("brightness",value)
	
func set_contrast(value: float):
	envo.adjustment_contrast = value
	add_data("contrast",value)
	
func set_saturation(value: float):
	envo.adjustment_saturation = value
	add_data("saturation",value)

func set_bloom(enable: bool):
	envo.glow_enabled = enable
	add_data("bloom",enable)

func set_full_screen(enable: bool):
	if(enable):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(640,360))
		print(DisplayServer.window_get_size())
		DisplayServer.window_set_mode.call_deferred(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	add_data("full_screen",enable)
		
func add_data(key,data,save : bool = true):
	settings_data[key] = data
	if(save):
		save_settings()

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_settings():
	var settings = FileAccess.open("user://settings.settings", FileAccess.WRITE)
	
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(settings_data)

	# Store the save dictionary as a new line in the save file.
	settings.store_line(json_string)
	
func get_save_files(path):
	var save_files  = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if(file_name.contains(".settings")):
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
		
		
func create_empty_settings():
	var save_files = get_save_files("user://")
	add_data("main_volume",0.0)
	add_data("music_volume",-17.7)
	add_data("sfx_volume",-14.1)
	add_data("brightness",0.57)
	add_data("contrast",1.0)
	add_data("saturation",1.0)
	add_data("bloom",true)
	add_data("full_screen",false)
	save_settings()
	return ("user://settings.settings")

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_settings():
	
	if not FileAccess.file_exists("user://settings.settings"):
		print("no save file at user://settings.settings")
		create_empty_settings()
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("user://settings.settings", FileAccess.READ)
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
		settings_data = loaded_data
