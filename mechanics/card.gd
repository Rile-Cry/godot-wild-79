extends Node2D

@export var cards : Array[CardResource]
@export var card_position := Vector2i(0, 0)
@export var card_frame := 0 as int
@export var sprite : Sprite2D

func _ready() -> void:
	add_to_group("cards")
	if card_frame == null:
		sprite.frame = MapManager.get_position(card_position)
	else:
		sprite.frame = card_frame
