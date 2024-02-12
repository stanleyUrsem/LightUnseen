extends AIState

class_name FleeState

var escape_point


func _pre_setup():
	setup(func():
		chance = remap(ai.stats.health,
		ai.stats.health_max/2.0 ,ai.stats.health_max,50,0)
		return ai.stats.health < ai.stats.health_max / 2.0
		,flee,0)

func flee():
	var mobSpawner = get_parent().get_parent()
	var spawn_points = mobSpawner.spawn_dict[ai.mob_type]
	var dist =9999
	var nearest_spawn_point
	for spawn_point in spawn_points:
		var spawn_dist = spawn_point.distance_to(ai.mobMovement.position)
		if(spawn_dist< dist):
			dist = spawn_dist
			nearest_spawn_point = spawn_point
	escape_point = nearest_spawn_point
	ai.mobMovement.moveToPoint(nearest_spawn_point,1.5)
	
