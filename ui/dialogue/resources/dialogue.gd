extends Resource

class_name  Dialogue

@export var dialogues = {}

# Load dialogue data
func load_from_json(file_path):
	var data = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data)
	if parsed_data:
		dialogues = parsed_data
	else:
		print("Failed to parse: ", parsed_data)
		
# Return individual NPC dialogues
func get_npc_dialogue(npc_id): 
	if npc_id in dialogues:
		return dialogues[npc_id]["tree"]
	else:
		return []
