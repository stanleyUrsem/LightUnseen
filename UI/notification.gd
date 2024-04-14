extends Control
@export var label : RichTextLabel
@export var icon : TextureRect

func setup_text(text):
	label.text = text
func setup_icon(p_icon):
	icon.texture = p_icon
