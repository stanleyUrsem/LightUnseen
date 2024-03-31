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


func _ready():
	healthManager = get_node("/root/MAIN/HUD/Node2D/V/Health")
	manaManager = get_node("/root/MAIN/HUD/Node2D/V/Mana/TextureProgressBar")
	hitNumberManager = get_node("/root/MAIN/HitNumberManager")
	eventsManager = get_node("/root/MAIN/EventsManager")
	
	eventsManager.OnSkillUsed.connect(onAbilityUse)
	stats = Stats.new(stats_resource)
	stats._set_max()
	if(old_mana > -1.0):
		stats.mana = old_mana
	if(old_hp > -1.0):
		stats.health = old_hp
	
	hittable.OnHit.connect(onHit)
	healthManager.setup(stats)
	manaManager.setup(stats)
	passives.setup()
	deathTransition = get_node("/root/MAIN/DeathTransition")
func reset():
	stats.reset()
	healthManager.setup(stats)
	manaManager.setup(stats)
	passives.setup()
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
func add_health(value,beyond_max = false):
	if(beyond_max):
		healthManager.add_health(value)
	else:
		healthManager.update_health(value)
func add_mana(value,beyond_max = false):
	print("Adding mana: ", value)
	
	var new_mana = stats.mana + value
	if(new_mana > stats.mana_max):
		if(!beyond_max):
			new_mana = stats.mana_max
			stats.mana = new_mana
			manaManager.mana = new_mana
			return false
		else:
			manaManager.max_value = new_mana
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
	if(stats.health <= 0):
		return
	print("GOT HIT")
	eventsManager.OnHitBy.emit(user.mob_type,damage)
	stats.health += damage
	#_ShowHit(get_parent().global_position,damage,false)
	healthManager.on_health_changed.emit(damage)
	if(stats.health<=0):
		eventsManager.OnDeath.emit()
		charMovement.animChar.death()

func activate_death():
	deathTransition.on_death(1.0)	
