extends CrystalGolemAI

@export var offset_radius : float
@export_group("Bomb")
@export var bomb_stats : SkillStats
@export_file() var bomb_path : String
@export var bomb_type : AttackState.AttackType
@export var bomb_transition : AnimationTransition
@export var death_explosion_cast : ShapeCast2D
@export var death_explosion_damage : float
var attack_bomb_state : AttackState
var hitNumberManager
func _setup():
	super()
	hitNumberManager = get_node("/root/MAIN/HitNumberManager")
	attack_bomb_state = AttackState.new("Bomb",rise_state,self,crystal_anims)
	attack_bomb_state.setup_vars(bomb_stats,bomb_path,leftBot,rightTop,
	att_root,bomb_type,bomb_transition)
func bombs_recovered():
	attack_bomb_state.current_cooldown = 0
func throw_bombs():
	var offset =  prng.random_unit_circle(false) * offset_radius
	leftBot.global_position += offset
	attack_bomb_state.create_hit()

func explode():
	if(death_explosion_cast.is_colliding()):
		for i in death_explosion_cast.get_collision_count():
			var col = death_explosion_cast.get_collider(i)
			var hit = col.get_node_or_null("Hittable")
			if(hit != null):
				hit.OnHit.emit(death_explosion_damage,self)
				hitNumberManager.onHit(col.global_position,
				death_explosion_damage,true)
			
func create_death_crystal(flip_h : bool):
	create_crystal(att_root.global_position,0,flip_h)

func _physics_process(delta):
	super(delta)
	
	if(player == null):
		return
	
	leftBot.global_position = player.global_position	
	
	

