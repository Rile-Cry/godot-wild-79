extends Node

var current_map : Array[Array]
var map_size := Vector2i(17, 17)
var map_position := Vector2i(0, 8)
var total_traveled : int = 0

## Grabs the number at a specific position
func get_position_value(pos: Vector2i) -> int:
	return current_map[pos.x][pos.y]

## Grabs the current map position
func get_current_position_value() -> int:
	print(map_position)
	return get_position_value(map_position)

## Moves the current map position based on chosen movement method
func move_current_position(type: int, up: bool = false) -> void:
	if up:
		map_position += Vector2i(1, -type)
	else:
		map_position += Vector2i(1, type)
	
	DeckManager.card_action()

## Generates a map for the game
func generate_current_map() -> void:
	for x in range(0, map_size.x):
		current_map.append([])
		for y in range(0, map_size.y):
			current_map[x].append(_check_weight_table(Vector2i(x, y)))
	
	current_map[map_position.x][map_position.y] = 0

## TODO: Balance changes to the weight sections -> Changes were made to card types for efficent pulling of card textures.
## This is where the [method _generate_current_map] checks against the weight table
## to either generate a basic number or an event card, etc.
func _check_weight_table(pos: Vector2i = Vector2i.ZERO) -> int:
	
	#var weight_table : Array = [
	#	[0,1,2,3,4,5,7,8],			# Base Numbers
	#	[6],						# 7's BABY
	#	[9,10,11,12],				# Effects
	#	[]							# Events ##TODO: Add events
	#]
	
	var weight_table : Array = [
		[], # Numbers
		6, # 7 Specifically
		[], # Effects
		[] # Events
	]
	var weight_types := PackedFloat32Array([
		1, # Numbers
		.3, # 7s
		.2, # Effects
		0, # Events
	])
	var weight_effects := PackedFloat32Array([])
	var weight_events := PackedFloat32Array([])
	for card_resource in DeckManager.card_resources.values():
		if card_resource.card_type == CardResource.CardType.NUMBER:
			if card_resource.card_id != 6:
				weight_table[0].append(card_resource.card_id)
		elif card_resource.card_type == CardResource.CardType.EFFECT:
			weight_table[2].append(card_resource.card_id)
			weight_effects.append(card_resource.card_weight)
		else:
			weight_table[3].append(card_resource.card_id)
			weight_events.append(card_resource.card_weight)
	
	## TODO: Double Check the Gaussian forumula for distance based scalars
	# weight = -distance(value, x) / sigma^2
	# sigma is the parameter controlling spread, ex
	# i found 15-20 worked well without getting the number toooo massive, but we may just want linear scaling.
	# var distance_scalar = exp(pow(-(pos.x / scalar),2))
	
	
	# TODO: Implement a growing weight table later on
	var weight_idx = Global.rng.rand_weighted(weight_types)
	var result = weight_table[weight_idx]
	if pos == map_position:
		return 0
	else:
		match(weight_idx):
			0:
				return result[randi_range(0, result.size() - 1)]
			1:
				return result
			2:
				return result[Global.rng.rand_weighted(weight_effects)]
			3:
				return result[Global.rng.rand_weighted(weight_events)]
			_:
				return 0
