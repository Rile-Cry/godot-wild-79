extends NinePatchRect

@export var master_volume : VSlider
@export var music_volume : VSlider
@export var sfx_volume : VSlider
@export var new_run_button : TextureButton
@export var res_button : TextureButton

func _ready() -> void:
	#Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.MASTERVOL, master_volume.value, null)
	#Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.OSTVOL, music_volume.value, null)
	#Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.SFXVOL, sfx_volume.value, null)
	
	res_button.pressed.connect(ScreenManager.change_size)

func _on_master_changed(value: float) -> void:
	pass
	#Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.MASTERVOL, value, null)

func _on_music_changed(value: float) -> void:
	#Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.OSTVOL, value, null)
	pass

func _on_sfx_changed(value: float) -> void:
	#Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.SFXVOL, value, null)
	pass

func _on_new_start_pressed() -> void:
	get_tree().paused = false
	#SoundManager.stop_all()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	GameGlobalEvents.exit_game.emit()
