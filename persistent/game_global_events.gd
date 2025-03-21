extends Node

signal debug_regen
signal debug_newseed(seed: int)
signal debug_restart
signal move_position
signal game_over

func changed_pull_count() -> void:
	if Global.get_var(Global.Vars.PULLS) <= 0:
		game_over.emit()
