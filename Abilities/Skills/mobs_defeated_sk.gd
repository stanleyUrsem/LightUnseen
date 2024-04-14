extends Skill



class_name mobs_defeated_sk

var type_hits_defeated : Dictionary


func _setup_vars(hits_types):
	for i in hits_types.size():
		var hits_type = hits_types[i]
		type_hits_defeated[hits_type.y] = Vector2i(hits_type.x,0)
func load_vars(loaded_data):
	var key = "%s_hits_types" % skillData.displayName
	if(!loaded_data.has(key)):
		return
	var loaded_hits_types = loaded_data[key]
	for i in loaded_hits_types.size():
		var loaded_hits = loaded_hits_types[i] as String
		loaded_hits = loaded_hits.replace("(","")
		loaded_hits = loaded_hits.replace(")","")
		var vector = loaded_hits.split(",")
		var type =  int(vector[0].replace(" ",""))
		var defeated = int(vector[1].replace(" ",""))
		type_hits_defeated[type].y = defeated
	var completed = 0
	for key2 in type_hits_defeated:
		var hits_defeated = type_hits_defeated[key2]	
		if(hits_defeated.y >= hits_defeated.x):
			completed += 1
	if(completed == type_hits_defeated.size()):
		_on_obtained()
		_disable_obtain_event()	
func _setup_obtain_event():
	eventsManager.OnEnemyKilled.connect(add_defeated)
func _disable_obtain_event():
	eventsManager.OnEnemyKilled.disconnect(add_defeated)
func save_vars():
	var hits_types : Array[Vector2i]
	for key in type_hits_defeated:
		var hits_defeated = type_hits_defeated[key]
		hits_types.append(Vector2i(key,hits_defeated.y))
	saveManager.add_data("%s_hits_types" % skillData.displayName,hits_types)		
func add_defeated(type):
	if(obtained):
		return
	
	if(!type_hits_defeated.has(type)):
		return
	type_hits_defeated[type].y += 1
	save_vars()
	#if(type == blue_slime_type):
		#blue_slime_defeated += 1
	#if(type == red_slime_type):
		#red_slime_defeated += 1
	var completed = 0
	var alpha = 0.0
	for key in type_hits_defeated:
		var hits_defeated = type_hits_defeated[key]	
		alpha += float(hits_defeated.y)/float(hits_defeated.x)
		if(hits_defeated.y >= hits_defeated.x):
			completed += 1
	alpha /= type_hits_defeated.size()
	eventsManager.OnSkillProgress.emit(self,alpha)
	#if(blue_slime_defeated >= blue_slime_needed && red_slime_defeated >= red_slime_needed):
	if(completed == type_hits_defeated.size()):
		eventsManager.OnEnemyKilled.disconnect(add_defeated)
		_on_obtained()



