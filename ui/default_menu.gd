extends NinePatchRect

@export var master_volume : VSlider
@export var music_volume : VSlider
@export var sfx_volume : VSlider
@export var new_run_button : TextureButton
@export var res_button : TextureButton
@onready var _master_bus := AudioServer.get_bus_index("Master")
@onready var _sfx_bus := AudioServer.get_bus_index("SFX")
@onready var _music_bus := AudioServer.get_bus_index("Music")


func _ready() -> void:
	#Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.MASTERVOL, master_volume.value, null)
	#Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.OSTVOL, music_volume.value, null)
	#Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.SFXVOL, sfx_volume.value, null)
	
	res_button.pressed.connect(ScreenManager.change_size)
	master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(_master_bus))
	sfx_volume.value = db_to_linear(AudioServer.get_bus_volume_db(_sfx_bus))
	music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(_music_bus))

func _on_master_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_master_bus, linear_to_db(value))

func _on_music_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_music_bus, linear_to_db(value))

func _on_sfx_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_sfx_bus, linear_to_db(value))

func _on_new_start_pressed() -> void:
	get_tree().paused = false
	#SoundManager.stop_all()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	GameGlobalEvents.exit_game.emit()


func _on_resolution_button_pressed() -> void:
	ScreenManager.change_size()
