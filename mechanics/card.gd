extends Node2D

@export var cards : Array[CardResource]
@export var card_position := Vector2i(0, 0)
@export var sprite : Sprite2D

func _ready() -> void:
	add_to_group("cards")
	sprite.frame_coords = get_frame(MapManager.get_position(card_position))
	name = "Card%s_%s" % [card_position.x, card_position.y]

func get_frame(val: int = 0) -> Vector2i:
	if val < 9:
		return Vector2i(val, 0)
	else:
		return Vector2i(0, val - 8)
