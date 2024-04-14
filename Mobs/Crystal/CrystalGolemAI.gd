extends AI

class_name CrystalGolemAI
@export var mobMovement : MobMovement
@export var crystal_template : PackedScene
@export var stamina_recovery : Vector2
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

var created_tile
var created_sprite

func _setup():
	super()
	

	
	crystal_corpse_data.append(CrystalCorpseData.new(291,1))
	crystal_corpse_data.append(CrystalCorpseData.new(310,2))
	crystal_corpse_data.append(CrystalCorpseData.new(311,2))
	crystal_corpse_data.append(CrystalCorpseData.new(308,3))
	
	
	crystal_anims = CrystalAnims.new()
	crystal_anims._setup(animTree)
	
	rise_state = RiseState.new("Rise", rootState,self,crystal_anims)
	rise_state.setup_vars(sightCast)
	states.append(rise_state)
	
	idle_state = Idle_State.new("Idle", rise_state,self,crystal_anims)
	idle_state.setup_vars(recovery_duration,stamina_min,stamina_recovery)
	states.append(idle_state)
	
	wander_state = WanderToPlayerState.new("Wander", rise_state,self,
	crystal_anims,5)
	wander_state.setup_vars(sightCast,wanderCast,wander_stamina_usage,
	Vector2.ZERO,prng)
	states.append(wander_state)
	stats = Stats.new(stats_resource)
	stats._set_max()

func create_crystal(pos,index, flip_h = false):
	create_tile(pos,index,flip_h)
	var resource_amount = crystal_corpse_data[index].resource_amount
	var collider = created_tile.get_child(1) as CollisionShape2D

	created_tile.set_meta("resource_amount", resource_amount)
	#created_tile.OnPickUp.connect(_erase_tile)
func create_tile(pos,index,flip_h):
	created_tile = crystal_template.instantiate()
	if(created_tile is Interactable):
		created_tile.setup_vars(prng)
	else:
		print("Created tile is not interactable: ", created_tile.name)
	created_sprite = created_tile.get_node("TileSprite") as Sprite2D
	created_sprite.frame = crystal_corpse_data[index].frame
	created_sprite.flip_h = flip_h
	get_parent().add_sibling.call_deferred(created_tile)
	created_tile.global_position = pos 


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


