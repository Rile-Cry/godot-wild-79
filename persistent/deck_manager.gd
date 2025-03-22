extends Node

var card_resources : Dictionary[int, CardResource]
var deck_path : StringName = "res://mechanics/cards/"
var track_set : Array[int] = []

func _ready() -> void:
	_load_cards()
	MapManager.generate_current_map()

func _load_cards() -> void:
	var dir_list := ResourceLoader.list_directory(deck_path)
	for res in dir_list:
		var card_res := ResourceLoader.load(deck_path + res) as CardResource
		card_resources.set(card_res.card_id, card_res)

# TODO: Write up the effects for the different cards.
# Also be able to handle score additions based on what's been collected.

func card_action() -> void:
	var current_card_id : int = MapManager.get_current_position_value()
	var current_card : CardResource = card_resources.get(current_card_id)
	print(current_card_id)
	
	if current_card.card_type == Genum.CardType.NUMBER:
		if current_card_id == 6:
			if track_set.get(0) == 6:
				track_set.append(6)
			else:
				track_set = [6]
		
		Global.set_var(Genum.Vars.SCORE, current_card_id + 1, true)
	
	Global.set_var(Genum.Vars.PULLS, -1, true)
