extends AI

class_name CrystalGolemAI
@export var crystal_template : PackedScene
@export var stamina_recovery : float
@export var stamina_min : float
@export var recovery_duration : float
@export var sightCast : ShapeCast2D
@export var wanderCast : ShapeCast2D
@export var wander_stamina_usage : float

@export_group("Attacks")
@export var leftBot : Marker2D
@export var rightTop : Marker2D
@export var hitMarker_root : Node2D
@export var att_root : Node2D


#Idle when stamina low
var idle_state : Idle_State

#Wander only towards player
var wander_state : WanderToPlayerState

#Rise when player near
var rise_state : RiseState


var player : Node2D
var crystal_anims : CrystalAnims

var crystal_corpse_data : Array[CrystalCorpseData]



func _setup():
	super()
	
	crystal_corpse_data.append(CrystalCorpseData.new(291,1))
	crystal_corpse_data.append(CrystalCorpseData.new(310,2))
	crystal_corpse_data.append(CrystalCorpseData.new(311,2))
	crystal_corpse_data.append(CrystalCorpseData.new(308,3))
	
	
	crystal_anims = CrystalAnims.new()
	crystal_anims._setup(get_node("./AnimationTree"))
	
	rise_state = RiseState.new("Rise", rootState,self,crystal_anims)
	rise_state.setup_vars(sightCast)
	
	idle_state = Idle_State.new("Idle", rise_state,self,crystal_anims)
	idle_state.setup_vars(recovery_duration,stamina_min,stamina_recovery)
	
	wander_state = WanderToPlayerState.new("Wander", rise_state,self,
	crystal_anims)
	wander_state.setup_vars(sightCast,wanderCast,wander_stamina_usage,
	Vector2.ZERO,prng)

func create_crystal(pos,index, flip_h = false):
	var crystal = crystal_template.instantiate()
	crystal.set_meta("resource_amount",
	 crystal_corpse_data[index].resource_amount)
	crystal.global_position = pos
	var sprite = crystal.get_node("TileSprite") as Sprite2D
	sprite.frame = crystal_corpse_data[index].frame
	sprite.flip_h = flip_h
	add_sibling(get_parent())
	
	

func on_death():
	crystal_anims.death()
	super()

func rotate_to_(angle : float):
	print("Rotate to target")
	
	att_root.rotation_degrees = angle 
	hitMarker_root.rotation_degrees = angle
func reset_rotation():
	print("Reset rotation")
	att_root.rotation_degrees = 0
	hitMarker_root.rotation_degrees = 0


