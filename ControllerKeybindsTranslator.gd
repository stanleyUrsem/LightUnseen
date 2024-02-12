class_name ControllerKeybindsTranslator

enum BUTTON_TYPE {SONY,XBOX,NINTENDO}

var sony_colours = {
	X = "purple",
	A = "blue",
	Y = "green",
	B = "red"
}

var xbox_colours = {
	X = "#4196F3",
	A = "#87D638",
	B = "#E33535",
	Y = "#EEB135",
	LT = "#999999",
	RT = "#999999",
	RB = "#999999",
	LB = "#999999"
}

func isolate_mouse_button(keybind:String):
	var direction = set_direction(keybind)
	var mouse = direction.replace("Mouse", "M")
	var button = mouse.replace("Button", "B")
	return button
	
func set_direction(keybind:String):
	var direction = ""
	direction = keybind.replace("Left", "L")
	direction = direction.replace("Right", "R")
	print("Stick\nDirection: ", direction)
	
	return direction
	
func isolate_button(keybind : String):
	var split = isolate_parenthesis(keybind).split(",")
	
	print("Button\nsplit: ", split)
	#var xbox = split[2].replace("Xbox", "").replace(" ","")
	var xbox = keybind.find("Xbox")
	xbox = keybind.length() - xbox
	print("xbox: ", xbox)
	xbox = keybind.right(xbox)
	print(xbox)
	xbox = xbox.substr(0,7)
	print(xbox)
	xbox = xbox.replace(",","").replace("Xbox","").replace(" ","")
	print(xbox)
	#var sony = split[1].replace("Sony","").replace(" ","")
	var sony = keybind.left(keybind.find("Sony"))
	print("sony: ", sony)
	#if(xbox.contains(")")):
		#xbox = xbox.split(")")[0]
	return "[color=%s]%s[/color]" % [xbox_colours[xbox],xbox]
	
func isolate_parenthesis(keybind: String):
	var end = keybind.find(")")
	print("\nparenthesis: ",end)
	var slice = keybind.get_slice("(",1)
	print("slice: ",slice)
	#var erased = slice.erase(end,13)
	#print("erased: ",erased)
	return slice
	
func isolate_stick(keybind:String):
	#var end = keybind.find(")")
	#
	#var slice = keybind.get_slice("(",1)
	#var erased = slice.erase(end,13)
	var split = isolate_parenthesis(keybind).split(",")
	print("Stick\nsplit: ", split)
	var first = split[0].replace("(","")
	print("first: ", first)
	
	return set_direction(first)


func translate_keybind(keybind:String):
	print("Translating:%s\n" % keybind)
	if(keybind.contains("Mouse")):
		return isolate_mouse_button(keybind)
	if(keybind.contains("D-pad")):
		return isolate_parenthesis(keybind).replace(")","")
	if(keybind.contains("Stick")):
		return isolate_stick(keybind)
	if(keybind.contains("Trigger") || keybind.contains("Button")):
		return isolate_button(keybind)
	if(keybind.contains("Physical")):
		return keybind.split("(")[0]
	return keybind

