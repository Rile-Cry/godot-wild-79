extends Node2D

@onready var dialogue_ui: Control = $DialogueUI

var _npc: Node2D = null

# Show dialogue with data
func show_dialogue(npc, text = "", options = {}):
	_npc = npc
	if text != "":
		# Show empty box
		dialogue_ui.show_dialogue(text, options)
	else:
		# Show populated data
		var dialogue = _npc.get_current_dialogue()
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
	var current_dialogue = _npc.get_current_dialogue()
	if current_dialogue == null:
		return
	
	# Update state
	var next_state = current_dialogue["options"].get(option, "start")
	_npc.grab_option_result(option)
	_npc.set_dialogue_state(next_state)
	
	## IF-ELSE VERSON
	 #Handle state transitions
	#if next_state == "end":
		##if npc.current_branch_index < npc.dialogue_resource.get_npc_dialogue(npc.npc_id).size() - 1:
			##npc.set_dialogue_branch(npc.current_branch_index + 1)
		#hide_dialogue()
		#GameGlobalEvents.transition_to_game.emit()
	#elif next_state == "exit":
		#npc.set_dialogue_state("start")
		#hide_dialogue()
	#else:
		#show_dialogue(npc)
		#
	
	## MATCH VERSION - this is a little more readable
	match next_state :
		"end" :
			hide_dialogue()
			GameGlobalEvents.transition_to_game.emit()
		"exit":
			_npc.set_dialogue_state("start")
			hide_dialogue()
		_: ## This is the "default" i.e. else of an if-else
			show_dialogue(_npc)
