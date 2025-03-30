extends Node

var current_map : Array[Array]
var map_size := Vector2i(20, 71)
var map_position := Vector2i(0, 0)
var weights : Array
var total_traveled : int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

## Grabs the number at a specific position
func get_position_value(pos: Vector2i) -> int:
	return current_map[pos.x][pos.y]

## Grabs the current map position
func get_current_position_value() -> int:
	#print(map_position)
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
	current_map = []
	_generate_weight_table()
	_get_starting_position()
	
	for x in range(0, map_size.x):
		current_map.append([])
		for y in range(0, map_size.y):
			current_map[x].append(_check_weight_table(Vector2i(x, y)))
	
	current_map[map_position.x][map_position.y] = 0

func _generate_weight_table() -> void:
	var weight_table : Array = [
		[], # Numbers
		[6], # 7 Specifically
		[], # Effects
		[] # Events
	]
	var weight_effects := PackedFloat32Array([])
	var weight_events := PackedFloat32Array([])
	for card_resource in DeckManager.card_resources.values():
		if card_resource.card_type == Genum.CardType.NUMBER:
			if card_resource.card_id != 6:
				weight_table.get(0).append(card_resource.card_id)
		elif card_resource.card_type == Genum.CardType.EFFECT:
			weight_table.get(2).append(card_resource.card_id)
			weight_effects.append(card_resource.card_weight)
		else:
			weight_table.get(3).append(card_resource.card_id)
			weight_events.append(card_resource.card_weight)
	
	var weight_types := PackedFloat32Array([
		1, # Numbers
		1, # 7s
		0, # Effects
		0, # Events
	])
	
	weights.append(weight_table)
	weights.append(weight_types)
	weights.append(weight_effects)
	weights.append(weight_events)

func _regen_weight_values(pos: Vector2i = map_position) -> void:
	var dist = abs(pos.x - map_position.x) + abs(pos.y - map_position.y)
	var i = 0
	var total_weight = 0
	for id in weights.get(0).get(2):
		var card : CardResource = DeckManager.card_resources.get(id)
		var coe : float = card.card_weight_coefficient
		var new_weight = card.card_weight + coe * dist
		weights.get(2).set(i, new_weight)
		total_weight += new_weight
		i += 1
	weights.get(1).set(2, total_weight)

func _get_starting_position() -> void:
	var map_y : int = map_size.y
	if map_y % 2 == 0:
		map_position = Vector2i(0, (map_y / 2) - 1)
	else:
		map_position = Vector2i(0, (map_y - 1) / 2)

func _check_weight_table(pos: Vector2i = map_position) -> int:
	_regen_weight_values(pos)
	var weight_idx = Global.rng.rand_weighted(weights.get(1))
	var result = weights[0][weight_idx]
	if pos == map_position:
		return 0
	else:
		match(weight_idx):
			0:
				return result[randi_range(0, result.size() - 1)]
			1:
				return result.get(0)
			2:
				return result[Global.rng.rand_weighted(weights.get(2))]
			3:
				return result[Global.rng.rand_weighted(weights.get(3))]
			_:
				return 0
