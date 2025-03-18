extends Node2D

@export var cards : Array[CardResource]
@export var card_position := Vector2i(0, 0)
@export var sprite : Sprite2D

func _ready() -> void:
	add_to_group("cards")
	sprite.frame = MapManager.get_position(card_position)
	
func randomize_card() -> void:
	card_position.x = randi_range(0, MapManager.map_size.x - 1)
	card_position.y = randi_range(0, MapManager.map_size.y - 1)
	sprite.frame = MapManager.get_position(card_position)
