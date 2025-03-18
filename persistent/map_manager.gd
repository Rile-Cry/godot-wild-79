extends Node

var current_map : Array[Array]
var map_size := Vector2(17, 17)
var map_position := Vector2(0, 9)

## Grabs the number at a specific position
func get_position(pos: Vector2) -> int:
	return current_map[pos.x][pos.y]

## Grabs the current map position
func get_current_position() -> int:
	return get_position(map_position)

## Generates a map for the game
func generate_current_map() -> void:
	for x in range(0, map_size.x):
		current_map.append([])
		for y in range(0, map_size.y):
			current_map[x].append(_check_weight_table())
	
	print(get_current_position())

## This is where the [method _generate_current_map] checks against the weight table
## to either generate a basic number or an event card, etc.
func _check_weight_table() -> int:
	return Global._rng.randi_range(0, 9)
