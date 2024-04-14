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
var is_attacking : bool
func _is_usable():
	return current_cooldown <= 0

func _pre_setup():
	is_attacking = false
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
	var root = ai.get_tree().root.get_child(0)
	root.add_child(hit)
	if(attack_type == AttackType.DYNAMIC_SIZED):
		hit.setup_vars(leftBot,rightTop,skillStats.damage
		,attackRoot.rotation_degrees)
		hit._setup(pos,ai,Vector2.ZERO,ai.prng)
	else:
		hit._setup_vars(skillStats.speed,skillStats.damage)
		var dir = (leftBot.global_position - rightTop.global_position).normalized()
		print("Attack direction: ", dir)
		hit._setup(attackRoot.global_position,ai,dir,ai.prng)
		
	hit.rotation_degrees = attackRoot.rotation_degrees
func reset():
	current_cooldown = skillStats.cooldown
	is_attacking = false
func update_cooldown(delta):
	if(current_cooldown > 0):
		current_cooldown -= delta
func _on_enter():
	super()
	ai.mobMovement.resetMovement()
	#reset()	
func _use():
	#if(is_attacking):
		#return
	#else:
		#is_attacking = true
		#allowExit = false
		
	#if(current_cooldown <= 0):
	#print("%s\nAttacking" % ai.get_parent().name)
	allowExit = false
	AnimatorHelper._playanimTransition(ai.animTree,animTransition)
	current_cooldown = skillStats.cooldown
	
