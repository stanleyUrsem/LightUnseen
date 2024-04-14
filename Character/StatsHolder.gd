extends Node2D

class_name StatsHolder

@export var stats_resource: StatsResource
@export var charMovement : CharacterMovement
@export var abilities: AbilityManager
@export var passives: PassivesManager
@export var hittable: Hittable
@export var hitPerSec :float
@export var old_hp : float
@export var old_mana : float
var stats : Stats
var healthManager : HealthManager
var manaManager : ManaManager
var deathTransition 
var hitNumberManager
var eventsManager : EventsManager
var sceneManager : SceneManager
var bgmManager
var prng : PRNG
var scene_invincibility : bool
var is_dead  : bool
var saveManager : SaveManager
var hp_added : float
var mana_added : float
func _ready():
	scene_invincibility = false
	prng = PRNG.new(123901923)
	healthManager = get_node("/root/MAIN/HUD/Node2D/V/Health")
	manaManager = get_node("/root/MAIN/HUD/Node2D/V/Mana/TextureProgressBar")
	hitNumberManager = get_node("/root/MAIN/HitNumberManager")
	eventsManager = get_node("/root/MAIN/EventsManager")
	bgmManager = get_node("/root/MAIN/BGMManager")
	saveManager = get_node("/root/MAIN/SaveManager")
	sceneManager = get_node("/root/MAIN/SceneManager")
	eventsManager.OnSkillUsed.connect(onAbilityUse)
	healthManager.on_health_changed.connect(chance_bgm_pitch)
	if(saveManager.loaded_data.has("hp_added")):
		hp_added = saveManager.loaded_data["hp_added"]
	if(saveManager.loaded_data.has("mana_added")):
		mana_added = saveManager.loaded_data["mana_added"]
	
	stats = Stats.new(stats_resource)
	stats._set_max()
	stats.mana_max = stats_resource.mana + mana_added
	stats.health_max = stats_resource.health + hp_added
	if(old_mana > -1.0):
		stats.mana = old_mana
	if(old_hp > -1.0):
		stats.health = old_hp
	
	hittable.OnHit.connect(onHit)
	healthManager.setup(stats)
	manaManager.setup(stats)
	passives.setup()
	
	if(stats.health > stats.health_max):
		stats.health = stats.health_max
	if(stats.mana > stats.mana_max):
		stats.mana = stats.mana_max
	deathTransition = get_node("/root/MAIN/DeathTransition")
	is_dead = false
func set_invincibility(enable):
	scene_invincibility = enable
func chance_bgm_pitch(value):
	#if(stats.health <= stats.health_max * 0.5):
	var alpha = remap(stats.health,0.0,stats.health_max * 0.5,0.0,1.0)
	var clamped_alpha = clamp(alpha,0.0,1.0)
	bgmManager.set_pitch(clamped_alpha)
func reset():
	bgmManager.set_pitch(1.0)	
	is_dead = false
	stats.reset()
	healthManager.setup(stats)
	manaManager.setup(stats)
	#passives.setup()
func setup_mana_hp(p_mana,p_hp):
	old_mana = p_mana
	old_hp = p_hp
	if(stats ==null):
		return
	stats.mana = old_mana
	stats.health = old_hp
	
func damage():
	onHit(hitPerSec,get_parent())
	
func _ShowHit(hit_pos,damage,is_mob):
	hitNumberManager.onHit(hit_pos,damage,is_mob)
func add_health(value,beyond_max = false,perma = false):
	if(beyond_max):
		stats.health_max += value
		healthManager.on_health_added.emit(stats.health_max)
		healthManager.on_health_changed.emit(stats.health)
		if(perma):
			hp_added += value
			saveManager.add_data("hp_added",hp_added,true)
		#healthManager.add_health(value)
	else:
		var new_health = stats.health + value
		if(new_health > stats.health_max):
			new_health = stats.health_max
		
		stats.health = new_health
		healthManager.on_health_changed.emit(new_health)
		
		#healthManager.update_health(value)
func add_mana(value,beyond_max = false,perma = false):
	print("Adding mana: ", value)

	if(beyond_max):
		stats.mana_max += value
		manaManager.max_value = stats.mana_max
		manaManager.mana = stats.mana
		if(perma):
			mana_added += value
			saveManager.add_data("mana_added",mana_added,true)
		return

	
	var new_mana = stats.mana + value
	if(new_mana > stats.mana_max):
		new_mana = stats.mana_max
		stats.mana = new_mana
		manaManager.mana = new_mana
		return false



	stats.mana  = new_mana
	manaManager.mana = new_mana
	#manaManager.max_value = new_mana
	return true
func onAbilityUse(data: AbilityData):
	print("Ability used: ", data.displayName)
	var new_mana = stats.mana + data.mana
	if(new_mana < 0):
		new_mana = 0
	stats.mana = new_mana
	manaManager.mana = new_mana
func onHit(damage,user):
	if(stats.health <= 0 && is_dead):
		return
	print("GOT HIT")
	if(user != null && user is AI):
		eventsManager.OnHitBy.emit(user.mob_type,damage)
	stats.health += damage
	#_ShowHit(get_parent().global_position,damage,false)
	healthManager.on_health_changed.emit(stats.health)
	
	if(stats.health<=0):
		var is_scene_10 = sceneManager.current_scene != null && sceneManager.current_scene.name == "Scene_10"
		var is_scene_aftermath = sceneManager.current_scene != null && sceneManager.current_scene.name == "Scene_Aftermath"
		if(scene_invincibility || is_scene_10 || is_scene_aftermath ):
			stats.health = stats.health_max * 0.5
			healthManager.on_health_changed.emit(stats.health)
			return
		is_dead = true
		eventsManager.OnDeath.emit()
		charMovement.animChar.death()

func activate_death():
	deathTransition.on_death(prng.range_f(0.0,1.0))	
