extends Node2D

@export var cards : Array[CardResource]
@export var card_position := Vector2i(0, 0)
@export var sprite : Sprite2D

func _ready() -> void:
	var pos = MapManager.get_position(card_position)
	print(pos)
	sprite.frame = MapManager.get_position(card_position)
	
