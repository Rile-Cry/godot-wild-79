extends NinePatchRect

@export var master_volume : VSlider
@export var music_volume : VSlider
@export var sfx_volume : VSlider
@export var new_run_button : TextureButton
@export var res_button : TextureButton
@export var quit_button : TextureButton

func _ready() -> void:
	Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.MASTERVOL, master_volume.value, null)
	Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.OSTVOL, music_volume.value, null)
	Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.SFXVOL, sfx_volume.value, null)
	
	res_button.pressed.connect(ScreenManager.change_size)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_quit_pressed() -> void:
	GameGlobalEvents.exit_game.emit()
