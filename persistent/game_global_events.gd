extends Node

@warning_ignore_start("unused_signal")
signal changed_stats
signal debug_regen
signal debug_newseed(seed: int)
signal debug_restart
signal exit_game
signal use_lever
signal reel_over
signal switch_hero
signal toggle_direction
signal bonus_get
signal level_up
signal bonus_level_sound
signal game_over
signal game_start
signal generation_complete
signal new_game
signal main_menu_closed
signal transition_to_game
signal difficulty_select
@warning_ignore_restore("unused_signal")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func changed_pull_count() -> void:
	if Global.get_var(Genum.Vars.PULLS) <= 0:
		print("Game Over")
		game_over.emit()
