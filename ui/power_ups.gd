extends Control

@export var bonus_atlas_texture : AtlasTexture
@export var lvl_atlas_texture : AtlasTexture
@export var bonus_texture : TextureRect
@export var lvl_texture : TextureRect
var bonus : Genum.BonusType
var level : Genum.BonusLevel
var v_offset := 12 as int # 12pixel v offset

var bonus_reference : Dictionary[Genum.BonusType, Vector2] = {
	Genum.BonusType.ABC : Vector2(0, 1),
	Genum.BonusType.XYZ : Vector2(93, 1),
	Genum.BonusType.ALPHABET : Vector2(186, 1),
	Genum.BonusType.ODD : Vector2(279, 1),
	Genum.BonusType.EVN : Vector2(372, 1),
	Genum.BonusType.ETO : Vector2(465, 1),
	Genum.BonusType.LCKA : Vector2(558, 1),
	Genum.BonusType.LCKB : Vector2(651, 1),
	Genum.BonusType.LCK : Vector2(744, 1),
	Genum.BonusType.BARTENDER : Vector2(837, 1),
	Genum.BonusType.OOF : Vector2(930, 1),
	Genum.BonusType.SEVENS : Vector2(1023, 1),
	Genum.BonusType.BONUS : Vector2(1116, 1)
}
var level_reference : Dictionary[Genum.BonusLevel, Vector2] = {
	Genum.BonusLevel.ONE : Vector2(0, 13),
	Genum.BonusLevel.TWO : Vector2(93, 13),
	Genum.BonusLevel.MAX : Vector2(186, 13)
}
var bonus_size := Vector2(93.0, 11.0)
var level_size := Vector2(45.0, 11.0)

# TODO: In the parent scene, make adjustments to fit text within the info panel
func _ready() -> void:
	#update_bonus(Genum.BonusType.OOF, Genum.BonusLevel.MAX)
	GameGlobalEvents.bonus_get.connect(update_bonus)


func update_bonus(new_bonus: Genum.BonusType, new_level: Genum.BonusLevel) -> void:
	bonus = new_bonus
	level = new_level
	var bonus_node : TextureRect = $VBoxContainer/HBoxContainer/TextureRect.duplicate()
	#bonus_node.position.y += v_offset
	var bonus_level_node : TextureRect = $VBoxContainer/HBoxContainer/TextureRect2.duplicate()
	#bonus_level_node.y += v_offset
	
	var bonus_rect := Rect2()
	var level_rect := Rect2()
	var margin_rect := Rect2()
	bonus_rect.position = bonus_reference[bonus]
	bonus_rect.size = bonus_size
	level_rect.position = level_reference[level]
	level_rect.size = level_size
	bonus_atlas_texture.atlas
	bonus_atlas_texture.region = bonus_rect
	bonus_texture.texture = bonus_atlas_texture
	lvl_atlas_texture.region = level_rect
	lvl_texture.texture = lvl_atlas_texture
	#$HBoxContainer.add_child()
