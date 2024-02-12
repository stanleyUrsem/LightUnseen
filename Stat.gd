extends Resource
class_name Stat

var id : int
var stat

func _init(p_id: int, p_stat):
	stat = p_stat
	id = p_id
