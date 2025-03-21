extends Node2D

@export var card_scene : PackedScene
var screen_offset : Vector2i
var offset : int = 1

func _ready() -> void:
	screen_offset = get_tree().root.get_size_with_decorations()
	screen_offset /= MapManager.map_size
	
	var pos := Vector2i.ZERO
	for x in MapManager.current_map:
		pos.y = 0
		for y in x:
			var card : Node2D = card_scene.instantiate()
			#card.card_frame = y
			card.card_position = pos
			add_child(card)
			card.position = Vector2(pos.x * screen_offset.x + offset, pos.y * screen_offset.y + offset)
			pos.y += 1
		pos.x += 1
	
	
