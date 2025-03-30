extends Node

var rng := RandomNumberGenerator.new() # The generator for the RNG Numbers
var _prior_runs : Array[int] = [] # Previous runs data
var _global_vars : Dictionary = { # Global dictionary, has all the variables encapsulated for get/set access
	Genum.Vars.MULTIPLIERS: 1, # The current multiplier
	Genum.Vars.PULLS: 15, # The amount of pulls available to the player
	Genum.Vars.BASE_SCORE: 0, # The base score the player has before multipliers
	Genum.Vars.SCORE:0 # The total score, after multipliers
}

var debug_active := false

var _move_weights : Array[float] = [1.0, 2.0]

func _ready() -> void:
	rng.seed = randi_range(0, 9999)
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	GameGlobalEvents.exit_game.connect(_on_exit_game)
	GameGlobalEvents.new_game.connect(new_run)

## The get function for accessing global variables.
func get_var(variable: Genum.Vars, idx: int = 0):
	if idx != null and typeof(_global_vars.get(variable)) == TYPE_ARRAY:
		return _global_vars.get(variable)[idx]
	return _global_vars.get(variable, null)

## The set function for writing to global variables.
func set_var(variable: Genum.Vars, value, modify: bool = false) -> void:
	var temp_var = _global_vars.get(variable, null)
	
	match(typeof(temp_var)):
		TYPE_ARRAY:
			temp_var.append(value)
			_global_vars.set(variable, temp_var)
		TYPE_INT:
			if modify:
				_global_vars.set(variable, temp_var + value)
				if variable == Genum.Vars.PULLS:
					GameGlobalEvents.changed_pull_count()
					GameGlobalEvents.changed_stats.emit()
				elif variable == Genum.Vars.SCORE:
					GameGlobalEvents.changed_stats.emit()
			else:
				_global_vars.set(variable, value)
		_:
			_global_vars.set(variable, value)

func new_run(new_seed: int) -> void:
	rng.seed = new_seed
	rng.state = 0
	
	MapManager.generate_current_map()
	set_var(Genum.Vars.SCORE, 0)
	set_var(Genum.Vars.PULLS, 15)
	set_var(Genum.Vars.BASE_SCORE, 0)
	set_var(Genum.Vars.MULTIPLIERS, 1)
	GameGlobalEvents.generation_complete.emit()
	
	get_tree().reload_current_scene()

func _on_exit_game() -> void:
	get_tree().quit()
