extends Node

var current_map : Array[Array]
var map_size := Vector2i(17, 17)
var map_position := Vector2i(0, 8)
var total_traveled : int = 0

## Grabs the number at a specific position
func get_position(pos: Vector2i) -> int:
	return current_map[pos.x][pos.y]

## Grabs the current map position
func get_current_position() -> int:
	return get_position(map_position)

## Generates a map for the game
func generate_current_map() -> void:
	for x in range(0, map_size.x):
		current_map.append([])
		for y in range(0, map_size.y):
			current_map[x].append(_check_weight_table(Vector2i(x, y)))
	
	var debug_check := double_check_positions()
	var base_check : int = 0
	for v in range(0, 7):
		base_check += debug_check[v]
	var high_check = (debug_check[7] + debug_check[8])
	
	print(debug_check)
	print(base_check)
	print(high_check)

func double_check_positions() -> Dictionary[int, int]:
	var pos_dict : Dictionary[int, int] = {}
	for v in range(0, 13):
		pos_dict.get_or_add(v, 0)
	
	for x in current_map:
		for y in x:
			pos_dict[y] += 1
	
	return pos_dict

## This is where the [method _generate_current_map] checks against the weight table
## to either generate a basic number or an event card, etc.
func _check_weight_table(pos: Vector2i = Vector2i.ZERO) -> int:
	var weight_table : Array = [
		[0, 1, 2, 3, 4, 5], # Base numbers 1 - 6
		[7, 8], # Base numbers 8 and 9
		6, # Number 7
		12, # Bar
		9, # Treasure
		11, # Bomb
	]
	# TODO: Implement a growing weight table later on.
	var weights := PackedFloat32Array([10, 9, 6, 4, 3, 2])
	var result = weight_table[Global.rng.rand_weighted(weights)]
	if pos == map_position:
		return 0
	else:
		if typeof(result) == TYPE_ARRAY:
			return result[Global.rng.randi_range(0, result.size() - 1)]
		else:
			# TODO: Add sub card-types, NUMBER,EFFECT,EVENT(TBD)
			if result <= 8:	## Workaround until we add card types to be created
				return result
			else:
				return Global.rng.randi_range(0,8) ## bring our random cards back into range once we resolve card types
