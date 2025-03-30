extends NinePatchRect


@onready var new_game_button : Button = $newGameButton

func _on_new_game_button_pressed() -> void:
	
	GameGlobalEvents.new_run.emit()
	
	pass # Replace with function body.
