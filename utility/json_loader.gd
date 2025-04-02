class_name JsonLoader 
extends Node

# Load JSON Data
func load_from_json(file_path) -> Dictionary:
	var data = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data)
	if parsed_data:
		return parsed_data
	else:
		return {}
	
	
