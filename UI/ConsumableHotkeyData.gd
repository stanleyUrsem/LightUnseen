extends "res://UI/HotkeyData.gd"

@export var amount_label : RichTextLabel

func set_amount(amount):
	amount_label.text = str(amount)
	
