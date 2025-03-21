extends Node

var location:=Vector2i(0,0)

func _ready() -> void:
	var pos = MapManager.get_current_position()
	var pie = 3
