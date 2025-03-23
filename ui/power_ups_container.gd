extends VBoxContainer

@export var power_up_scene : PackedScene

const MAX_COLLECTION : int = 12

func _ready() -> void:
	DeckManager.added_bonus.connect(_add_power_up)


func _add_power_up(bonus: Genum.BonusType, level: Genum.BonusLevel) -> void:
	var found : bool = false
	for child in get_children():
		if child.bonus == bonus:
			found = true
			if child.level != level and level < 2:
				child.update_bonus(bonus, level)
			

	if not found:
		var new_power_up : Control = power_up_scene.instantiate()
		add_child(new_power_up)
		move_child(new_power_up, 0)
		new_power_up.update_bonus(bonus, level)
