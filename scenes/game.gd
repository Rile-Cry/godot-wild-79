extends Node

@export var reels : Array[Node2D]

func _ready() -> void:
	_update_reel_positions()

func _update_reel_positions() -> void:
	var i : int = 0
	var current_position := MapManager.map_position
	for reel in reels:
		print("Reel Position: %s" % (current_position + Vector2i(i, 0)))
		reel.update_reel(current_position + Vector2i(i, 0))
		i += 1
