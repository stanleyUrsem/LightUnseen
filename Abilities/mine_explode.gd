extends MovableAbilityaction

@export var movement_curve : Curve
@export var duration : float
@export var animTree : AnimationTree
var current_duration : float 
var exploding:bool
var saved_direction : Vector2
func _on_setup():
	super()
	current_duration = 0.0
	exploding = false
	saved_direction = direction
func _physics_process(delta):
	var alpha = remap(current_duration,0.0,duration,0.0,1.0)
	if(current_duration < duration):
		direction = saved_direction * movement_curve.sample(alpha)
		current_duration += delta
	
	if(alpha >= 1.0 && !exploding):
		AnimatorHelper._playanimTreeBlend2D(animTree,"Throw",1.0)
		exploding = true
		
	super(delta)
