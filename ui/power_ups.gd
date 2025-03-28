extends Control

@export var bonus_sprite : Sprite2D
@export var level_sprite : Sprite2D
var bonus := Genum.BonusType.NONE
var level := Genum.BonusLevel.ONE

var bonus_reference : Dictionary[Genum.BonusType, Vector2i] = {
	Genum.BonusType.ABC : Vector2i(0, 0),
	Genum.BonusType.XYZ : Vector2i(1, 0),
	Genum.BonusType.ALPHABET : Vector2i(2, 0),
	Genum.BonusType.ODD : Vector2i(3, 0),
	Genum.BonusType.EVN : Vector2i(4, 0),
	Genum.BonusType.ETO : Vector2i(5, 0),
	Genum.BonusType.LCKA : Vector2i(6, 0),
	Genum.BonusType.LCKB : Vector2i(7, 0),
	Genum.BonusType.LCK : Vector2i(8, 0),
	Genum.BonusType.BARTENDER : Vector2i(9, 0),
	Genum.BonusType.OOF : Vector2i(10, 0),
	Genum.BonusType.SEVENS : Vector2i(11, 0),
	Genum.BonusType.BONUS : Vector2i(12, 0)
}
var level_reference : Dictionary[Genum.BonusLevel, Vector2i] = {
	Genum.BonusLevel.ONE : Vector2i(0, 1),
	Genum.BonusLevel.TWO : Vector2i(1, 1),
	Genum.BonusLevel.MAX : Vector2i(2, 1)
}

func _get_current_bonus() -> Vector2i :
	return Vector2i(bonus,level)

# TODO: In the parent scene, make adjustments to fit text within the info panel
func _ready() -> void:
	#update_bonus(Genum.BonusType.OOF, Genum.BonusLevel.MAX)
	update_bonus(bonus, level)
	GameGlobalEvents.bonus_get.connect(update_bonus)

func update_bonus(new_bonus: Genum.BonusType, new_level: Genum.BonusLevel) -> void:
	bonus = new_bonus
	level = new_level
	
	if bonus != Genum.BonusType.NONE:
		show()
		bonus_sprite.frame_coords = bonus_reference[bonus]
		level_sprite.frame_coords = level_reference[level]
		GameGlobalEvents.bonus_level_sound.emit(level)
	else:
		hide()
