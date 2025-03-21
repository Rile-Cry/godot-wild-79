extends Node

var card_resources : Dictionary[int, CardResource]
var deck_path : StringName = "res://mechanics/cards/"

func _ready() -> void:
	_load_cards()

func _load_cards() -> void:
	var dir_list := ResourceLoader.list_directory(deck_path)
	for res in dir_list:
		var card_res := ResourceLoader.load(deck_path + res) as CardResource
		card_resources.set(card_res.card_id, card_res)
