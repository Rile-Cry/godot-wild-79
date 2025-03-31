extends Node2D

@onready var dialogue_ui: Control = $DialogueUI

var npc: Node = null

# Show dialogue with data
func show_dialogue(npc, text = "", options = {}):
	if text != "":
		# Show empty box
		dialogue_ui.show_dialogue(text, options)
	else:
		# Show populated data
		var dialogue = npc.get_current_dialogue()
		print(dialogue)
		if dialogue == null:
			return
		dialogue_ui.show_dialogue(dialogue["text"],dialogue["options"])

# Hide dialogue
func hide_dialogue():
	dialogue_ui.hide_dialogue()

# Dialogue state management
func handle_dialogue_option(option):
	# Get current dialogue branch
	var current_dialogue = npc.get_current_dialogue()
	if current_dialogue == null:
		return
	
	# Update state
	var next_state = current_dialogue["options"].get(option, "start")
	npc.set_dialogue_state(next_state)
	# Handle state transitions
	if next_state == "end":
		if npc.current_branch_index < npc.dialogue_resource.get_npc_dialogue(npc.npc_id).size() - 1:
			npc.set_dialogue_branch(npc.current_branch_index + 1)
		hide_dialogue()
	elif next_state == "exit":
		npc.set_dialogue_state("start")
		hide_dialogue()
	else:
		show_dialogue(npc)
	
	
