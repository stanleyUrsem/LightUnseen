extends Cutscene

class_name LinesCutscene

@export var lines : Array[String]
var panel : PanelContainer
var base_anim_prefix : String
func _setup_texts():
	panel = label.get_parent()
	base_anim_prefix = anim_prefix
	for line in lines:
		anim_texts.append(line)

func animate_text_ln(index : int):
	_set_anim_text(index)
	animate_text()

func _animation_complete():
	var returned  = super()
	if(returned):
		panel.modulate.a = 0.0
func empty_text():
	super()
	panel.modulate.a = 0.0
func animate_text():
	super()
	panel.modulate.a = 1.0
	
func set_anim_prefix(prefix : String):
	return
	anim_prefix = prefix
