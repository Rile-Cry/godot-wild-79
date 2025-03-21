extends Node

enum MoveType {
	WARRIOR,
	RANGER,
	ROGUE
}

var current_map : Array[Array]
var map_size := Vector2i(17, 17)
var map_position := Vector2i(0, 8)
var total_traveled : int = 0

## Grabs the number at a specific position
func get_position_value(pos: Vector2i) -> int:
	return current_map[pos.x][pos.y]

## Grabs the current map position
func get_current_position_value() -> int:
	return get_position_value(map_position)

## Moves the current map position based on chosen movement method
func move_current_position(type: MoveType, up: bool = true) -> void:
	match(type):
		MoveType.WARRIOR:
			map_position.x += 1
		MoveType.ROGUE:
			if up:
				map_position += Vector2i(1, -1)
			else:
				map_position += Vector2i(1, 1)
		MoveType.RANGER:
			if up:
				map_position += Vector2i(1, -2)
			else:
				map_position += Vector2i(1, 2)

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

## TODO: Balance changes to the weight sections -> Changes were made to card types for efficent pulling of card textures.
## This is where the [method _generate_current_map] checks against the weight table
## to either generate a basic number or an event card, etc.
func _check_weight_table(pos: Vector2i = Vector2i.ZERO) -> int:
	
	var weight_table : Array = [
		[0,1,2,3,4,5,7,8],			# Base Numbers
		[6],						# 7's BABY
		[9,10,11,12],				# Effects
		[]							# Events ##TODO: Add events
	]
	
	## TODO: Double Check the Gaussian forumula for distance based scalars
	# weight = -distance(value, x) / sigma^2
	# sigma is the parameter controlling spread, ex
	# i found 15-20 worked well without getting the number toooo massive, but we may just want linear scaling.
	# var distance_scalar = exp(pow(-(pos.x / scalar),2))
	
	
	# TODO: Implement a growing weight table later on.
	var weights := PackedFloat32Array([1,.3,.2,0])
	var result = weight_table[Global.rng.rand_weighted(weights)]
	if pos == map_position:
		return 0
	else:
		if typeof(result) == TYPE_ARRAY:
			return result[Global.rng.randi_range(0, result.size() - 1)]
		else:
			return result
			
			
## TODO: Need to roll reels

## TODO: Need to make reels invisible if they are y+/-3 * cardheight +1 (for margins)
