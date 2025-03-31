extends Node2D


# Dialogue vars
@export var dialogue_resource: Dialogue
@export var npc_id: String
@onready var dialogue_manager: Node2D = $DialogueManager
var current_state = "start"
var current_branch_index = 0



func _ready() -> void:
	#SoundManager.play_music(Sounds.music_shop, 1.0, "Music")
	dialogue_resource.load_from_json("res://ui/dialogue/resources/dialogue_data.json")
	# Initialize npc reference
	dialogue_manager.npc = self
	GameGlobalEvents.transition_to_game.connect(transition_to_game)
	

func start_dialogue():
	var cashier_dialogues = dialogue_resource.get_npc_dialogue(npc_id)
	if cashier_dialogues.is_empty():
		return
	dialogue_manager.show_dialogue(self)
	

func get_current_dialogue():
	var cashier_dialogues = dialogue_resource.get_npc_dialogue(npc_id)
	if current_branch_index < cashier_dialogues.size():
		for dialogue in cashier_dialogues[current_branch_index]["dialogues"]:
			if dialogue["state"] == current_state:
				return dialogue
	return null

func set_dialogue_branch(branch_index):
	current_branch_index = branch_index
	current_state = "start"
	
func set_dialogue_state(state):
	current_state = state

func transition_to_game():
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position:y", -50, .2)
		tween.play()
		await tween.finished
		var tween1 = get_tree().create_tween()
		SoundManager.play_music(Sounds.music_low, .75, "Music")
		tween1.tween_property(self, "position:y", 200, .75)
		tween1.play()
		await tween1.finished
		GameGlobalEvents.game_start.emit()
		
