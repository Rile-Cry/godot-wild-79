extends Node

var _global_vars : Dictionary = {
	"score": 0, # The score the player accrues as they play
}

func get_var(variable: String):
	return _global_vars.get(variable, null)

func set_var(variable: String, value) -> void:
	_global_vars.set(variable, value)


func save() -> Dictionary:
	var save_dict : Dictionary = {}
	for variable in _global_vars.keys():
		save_dict.set(variable, _global_vars.get(variable))
	
	return save_dict

func save_game() -> void:
	var save_file := FileAccess.open("user://data.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_file.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://data.save"):
		return
	
	var save_file := FileAccess.open("user://data.save", FileAccess.READ)
	var json_string = save_file.get_line()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	
	var loaded_data = json.data
	if typeof(loaded_data) != TYPE_DICTIONARY:
		print("Loaded data error: Not a dictionary")
		return
	
	for variable in loaded_data.keys():
		set_var(variable, loaded_data.get(variable))
