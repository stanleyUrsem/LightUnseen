extends Skill

class_name slam_sk

var transform_skill : Skill
var red_slime_needed : int
var red_slime_type : int
var red_slime_defeated : int
var transform_obtained : bool 
var enough_slimes : bool

func _setup_vars(p_red_slime_needed,p_red_slime_type,p_transform_skill):
	transform_skill = p_transform_skill
	red_slime_needed = p_red_slime_needed
	red_slime_type = p_red_slime_type
	enough_slimes = false
	transform_obtained = false
func load_vars(loaded_data):
	var key = "slam_kills"
	if(loaded_data.has(key)):
		red_slime_defeated = loaded_data[key]
		if(red_slime_defeated >= red_slime_needed):
			enough_slimes = true	
			
	var key2 = "carion_skills"
	if(loaded_data.has(key2)):
		var carion_skills = loaded_data[key2]
		if(carion_skills.has(transform_skill.display_name)):
			transform_obtained = true
	
	if(enough_slimes && transform_obtained):
		_on_obtained()
		_disable_obtain_event()
	
func _setup_obtain_event():
	if(obtained):
		return
	eventsManager.OnEnemyKilled.connect(add_defeated)
	eventsManager.OnSkillObtained.connect(_check_obtained)
func _disable_obtain_event():
	eventsManager.OnEnemyKilled.disconnect(add_defeated)
	eventsManager.OnSkillObtained.disconnect(_check_obtained)
func save_vars():
	saveManager.add_data("slam_kills",red_slime_defeated)	
func add_defeated(type):
	if(obtained):
		return
	
	
	if(type == red_slime_type):
		red_slime_defeated += 1.0
		save_vars()
		eventsManager.OnSkillProgress.emit(self,
		float(red_slime_defeated)/float(red_slime_needed))
	if(red_slime_defeated >= red_slime_needed):
		enough_slimes = true
		eventsManager.OnEnemyKilled.disconnect(add_defeated)
	if(enough_slimes && transform_obtained):
		_on_obtained()
		
func _check_obtained(skill):
	if(obtained):
		return
	
	if(skill.displayName == transform_skill.display_name):
		eventsManager.OnSkillObtained.disconnect(_check_obtained)
		transform_obtained = true
	if(enough_slimes && transform_obtained):
		_on_obtained()


