extends Sprite2D

@export var left_up_frame : int
@export var right_up_frame : int
@export var left_down_frame : int
@export var right_down_frame :int
@export var side_frame :int
@export var straight_frame :int
@export var center_frame :int

func center():
	setup_frame(center_frame)

func left_down():
	setup_frame(left_down_frame)
	
func right_down():
	setup_frame(right_down_frame)
	
func left_up():
	setup_frame(left_up_frame)

func right_up():
	setup_frame(right_up_frame)

func side_l():
	setup_frame(side_frame)
	
func side_r():
	setup_frame(side_frame,true)

func straight_u():
	setup_frame(straight_frame)

func straight_b():
	setup_frame(straight_frame,false,true)
	
func setup_frame(index, reverseX = false, reverseY = false):
	frame = index
	scale.x = -1.0 if reverseX else 1.0
	scale.y = -1.0 if reverseY else 1.0

