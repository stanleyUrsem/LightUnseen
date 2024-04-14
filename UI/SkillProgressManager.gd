extends VBoxContainer

@export var bar_template : PackedScene
var eventsManager : EventsManager
var created_bars : Dictionary

func _ready():
	eventsManager = get_node("/root/MAIN/EventsManager") as EventsManager
	eventsManager.OnSkillProgress.connect(use_bar)

func create_bar():
	var created_bar = bar_template.instantiate()
	add_child(created_bar)
	var skill_progress = created_bar.get_node("TextureProgressBar")
	return skill_progress

func use_bar(skill,alpha):
	var bar = null
	if(!created_bars.has(skill)):
		bar = create_bar()
		created_bars[skill] = bar
	else:
		bar = created_bars[skill]
	var new_progress = alpha * 100.0
	if(bar.progress >= 100.0 && new_progress >= 100.0):
		return
	bar.fade_in()
	bar.progress = new_progress
