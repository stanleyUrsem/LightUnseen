extends Cutscene

@export var cutsceneDirector : CutsceneDirector
@export var saveManager : SaveManager
@export var buttons : Array[Button]
var prologue_1 = "This door can lead towards your salvation\nOr your doom"
var prologue_2 = "Marked one, what will you choose knowing it can lead to either of them?"
var prologue_3 = "If that is your choice, then I wish you good luck"
func _ready():
	super()
	saveManager = get_node("/root/Prologue/SaveManager")
	
	for btn in buttons:
		btn.pressed.connect(on_button_press.bind(btn))
func on_button_press(btn):
	for other in buttons:
		other.visible = other.name == btn.name
		other.disabled = true
	cutsceneDirector.resume()
func set_prologue_played():
	#var saveManager = get_node("/root/Prologue/SaveManager")
	saveManager.add_data("played_prologue", true)
func _setup_texts():
	anim_texts.append(prologue_1)
	anim_texts.append(prologue_2)
	anim_texts.append(prologue_3)

