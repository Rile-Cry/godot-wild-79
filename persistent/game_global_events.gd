extends Node

signal changed_stats
signal debug_regen
signal debug_newseed(seed: int)
signal debug_restart
signal use_lever
signal reel_over
signal switch_hero
signal toggle_direction
signal bonus_get
signal bonus_level_sound
signal game_over
signal game_start


func changed_pull_count() -> void:
	if Global.get_var(Genum.Vars.PULLS) <= 0:
		print("Game Over")
		game_over.emit()
