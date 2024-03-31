extends Resource

class_name SkillData

@export var displayName : String
@export_multiline var description : String
@export var icon : AtlasTexture
@export var icon_mat : Material
enum form_enum {Carion = 0 ,Slime = 1,CrystalGolem = 2, Consumable = 4}
@export var form_type : form_enum
