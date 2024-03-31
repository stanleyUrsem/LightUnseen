extends AIState

class_name AttackState
var skillStats : SkillStats
var current_cooldown : float
var skillHitPath : String
var animTransition : AnimationTransition
var skillHit
var leftBot
var rightTop
var attackRoot
enum AttackType {DYNAMIC_SIZED, MOVABLE}
var attack_type : AttackType
func _is_usable():
	return current_cooldown <= 0

func _pre_setup():
	setup(_is_usable,_use,1)

func setup_vars(p_skillStats:SkillStats,p_skillHitPath:String,
p_leftBot, p_rightTop, p_attackRoot,p_attack_type : AttackType
,p_animTransition : AnimationTransition):
	
	skillStats = p_skillStats
	skillHitPath = p_skillHitPath
	skillHit = load(skillHitPath)
	leftBot = p_leftBot
	rightTop = p_rightTop
	attackRoot = p_attackRoot
	attack_type = p_attack_type
	animTransition = p_animTransition

func create_hit():
	var hit = skillHit.instantiate()
	var x = leftBot.global_position.x
	var y= (leftBot.global_position.y + rightTop.global_position.y) / 2.0
	var pos = Vector2(x,y)
	if(attack_type == AttackType.DYNAMIC_SIZED):
		hit.setup_vars(leftBot,rightTop,skillStats.damage)
		hit._setup(pos,ai,Vector2.ZERO,ai.prng)
	else:
		hit.setup_vars(skillStats.speed,skillStats.damage)
		var dir = (attackRoot.global_position - leftBot.global_position).normalized()
		hit._setup(attackRoot.global_position,ai,dir,ai.prng)
		
	hit.rotation_degrees = attackRoot.rotation_degrees
	var root = ai.get_tree().root.get_child(0)
	root.add_child(hit)
	
func update_cooldown(delta):
	current_cooldown -= delta
func _on_enter():
	super()
	ai.mobMovement.resetMovement()	
func _use():
	current_cooldown = skillStats.cooldown
	AnimatorHelper._playanimTransition(ai.animTree,animTransition)
