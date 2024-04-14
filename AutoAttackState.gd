extends AIState

class_name AutoAttackState

var anim_transition : AnimationTransition

#ONE ANIMATION TAKES CARE OF EVERYTHING

#THIS DOES NEED CREATE HIT THO SAME AS ATTACK STATE
#NO COOLDOWN NEEDED
var skillStats : SkillStats
var skillHitPath : String
var animTransition : AnimationTransition
var skillHit
var leftBot
var rightTop
var attackRoot
var attack_type : AttackState.AttackType
var usable : bool
func _is_usable():
	return usable

func _pre_setup():
	setup(_is_usable,_use,5)

func setup_vars(p_skillStats:SkillStats,p_skillHitPath:String,
p_leftBot, p_rightTop, p_attackRoot,p_attack_type : AttackState.AttackType
,p_animTransition : AnimationTransition):
	
	skillStats = p_skillStats
	skillHitPath = p_skillHitPath
	skillHit = load(skillHitPath)
	leftBot = p_leftBot
	rightTop = p_rightTop
	attackRoot = p_attackRoot
	attack_type = p_attack_type
	animTransition = p_animTransition
	usable = true
	
func create_hit():
	var hit = skillHit.instantiate()
	var x = leftBot.global_position.x
	var y = leftBot.global_position.y
	#var y= (leftBot.global_position.y + rightTop.global_position.y) / 2.0
	var pos = Vector2(x,y)
	var root = ai.get_tree().root.get_child(0)
	root.add_child(hit)
	if(attack_type == AttackState.AttackType.DYNAMIC_SIZED):
		hit.setup_vars(leftBot,rightTop,skillStats.damage
		,attackRoot.rotation_degrees)
		hit._setup(pos,ai,Vector2.ZERO,ai.prng)
	else:
		hit._setup_vars(skillStats.speed,skillStats.damage)
		var dir = (leftBot.global_position - rightTop.global_position).normalized()
		print("Attack direction: ", dir)
		hit._setup(attackRoot.global_position,ai,dir,ai.prng)
		
	hit.rotation_degrees = attackRoot.rotation_degrees
	return hit
func reset():
	usable = true

func _on_enter():
	super()
	ai.mobMovement.resetMovement()
	AnimatorHelper._playanimTransition(ai.animTree,animTransition)
	#print("%s\nAttacking" % ai.get_parent().name)
	allowExit = false
	usable = false
func _on_exit():
	allowExit = true	
	##reset()	
func _use():
	pass
	##if(is_attacking):
		##return
	##else:
		##is_attacking = true
		##allowExit = false
		#
	##if(current_cooldown <= 0):
	
