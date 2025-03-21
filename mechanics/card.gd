extends Node2D

@export var card_position := Vector2i(0, 0)
@export var highlight_sprite : Sprite2D
@export var sprite : Sprite2D
var card_id : int = 0
var card_width

func _ready() -> void:
	add_to_group("cards")
	card_id = get_tree().get_node_count_in_group("cards")
	update_card()
	name = "Card%s_%s" % [card_position.x, card_position.y]

func get_frame(val: int = 0) -> Vector2i:
	return DeckManager.card_resources.get(val).card_texture_position

func update_card(pos: Vector2i = card_position) -> void:
	if pos != card_position:
		card_position = pos
	sprite.frame_coords = get_frame(MapManager.get_position_value(card_position))

func highlight(id: int) -> void:
	print("Called")
	if id == card_id:
		highlight_sprite.show()
	else:
		highlight_sprite.hide()
