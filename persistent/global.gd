extends Node

## Enum for the [param _global_vars] dictionary to allow for readability but avoid strings
enum Vars {
	MULTIPLIERS,
	PULLS,
	SCORE,
	TILE_DIST
}

var rng := RandomNumberGenerator.new() # The generator for the RNG Numbers
var _prior_runs : Array[int] = [] # Previous runs data
var _global_vars : Dictionary = { # Global dictionary, has all the variables encapsulated for get/set access
	Vars.MULTIPLIERS: [], # The collection of multipliers
	Vars.PULLS: 9, # The amount of pulls available to the player
	Vars.SCORE: 0, # The score the player accrues as they play
	Vars.TILE_DIST: 0, # How far the player has moved from the start
}
var _move_weights : Array[float] = [1.0, 2.0]

func _ready() -> void:
	rng.seed = randi_range(0, 9999)
	GameGlobalEvents.debug_newseed.connect(_on_new_seed_restart)

## The get function for accessing global variables.
func get_var(variable: Vars, idx: int = 0):
	if idx != null and typeof(_global_vars.get(variable)) == TYPE_ARRAY:
		return _global_vars.get(variable)[idx]
	return _global_vars.get(variable, null)

## The set function for writing to global variables.
func set_var(variable: Vars, value, modify: bool = false) -> void:
	var temp_var = _global_vars.get(variable, null)
	
	match(typeof(temp_var)):
		TYPE_ARRAY:
			temp_var.append(value)
			_global_vars.set(variable, temp_var)
		TYPE_INT:
			if modify:
				_global_vars.set(variable, temp_var + value)
				if variable == Vars.PULLS:
					GameGlobalEvents.changed_pull_count()
				elif variable == Vars.SCORE:
					GameGlobalEvents.changed_score.emit()
			else:
				_global_vars.set(variable, value)
		_:
			_global_vars.set(variable, value)

## Produces the Dictionary containing all the global variables.
func save() -> Dictionary:
	var save_dict : Dictionary = {}
	var i : int = 0
	for run in _prior_runs:
		save_dict[i] = run
		i += 1
	
	return save_dict

## The actual save function that writes all relevant save data to a file.
func save_game() -> void:
	var save_file := FileAccess.open("user://old_runs.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_file.store_line(json_string)

## The function that loads a save file, assuming it exists, and sets all relavent parameters
## and nodes to match the values.
func load_game():
	if not FileAccess.file_exists("user://data.save"):
		return
	
	# The save file to be accessed
	var save_file := FileAccess.open("user://data.save", FileAccess.READ)
	var json_string = save_file.get_line()
	save_file.close() # At the moment there should only be one line so the file closes immediately
	
	# Parsing the Json found in the save file
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	
	# Making sure the loaded data is of type dictionary for global variables
	# Though this is only temporary depending on other persistents
	var loaded_data = json.data
	if typeof(loaded_data) != TYPE_DICTIONARY:
		print("Loaded data error: Not a dictionary")
		return
	
	# Actually loading in the variables.
	for run in loaded_data:
		_prior_runs.append(run)

func _on_new_seed_restart(new_seed: int) -> void:
	rng.seed = new_seed
	rng.state = 0
