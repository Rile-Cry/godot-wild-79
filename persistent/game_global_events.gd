extends Node

signal game_over

func changed_pull_count() -> void:
	if Global.get_var(Global.Vars.PULLS) <= 0:
		game_over.emit()
