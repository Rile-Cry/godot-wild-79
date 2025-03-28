extends NinePatchRect

@export var master_volume : VSlider
@export var music_volume : VSlider
@export var sfx_volume : VSlider
@export var new_run_button : TextureButton
@export var res_button : TextureButton

func _ready() -> void:
	
	res_button.pressed.connect(ScreenManager.change_size)

func _on_new_start_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	GameGlobalEvents.exit_game.emit()
