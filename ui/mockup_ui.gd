extends CanvasLayer

@onready var lever = $Lever
@onready var lever_button : Button = $Lever/LeverButton
@onready var sidePanel = $SidePanel
@onready var characters = $LowerButtonPanel/Buttons/CharacterSelectScreen/Characters
@onready var direction_arrow = $"LowerButtonPanel/Buttons/Arrow Facing/Arrow Animation"
@onready var arrow = $Arrow
@onready var optionsMenu = $OptionsMenu
@onready var buttons = $LowerButtonPanel/Buttons
@onready var optionsButton = $LowerButtonPanel/Buttons/OptionsButton
@onready var infoButton = $LowerButtonPanel/Buttons/InfoButton
@onready var upDownButton = $LowerButtonPanel/Buttons/UpDownButton
@onready var swapButton = $LowerButtonPanel/Buttons/SwapButton
@onready var leverButton = $Lever/LeverButton

var menuOpen = false

func _ready() -> void:
	GameGlobalEvents.reel_over.connect(_on_reel_finished)
	direction_arrow.play("arrows",0)
	disable_buttons()
	
func disable_buttons():
	infoButton.disabled = true
	upDownButton.disabled = true
	swapButton.disabled = true
	leverButton.disabled = true
	optionsButton.disabled = true

func enable_buttons():
	infoButton.disabled = false
	upDownButton.disabled = false
	swapButton.disabled = false
	leverButton.disabled = false
	optionsButton.disabled = false

func change_hero(new_hero: Genum.Classes,up:bool) -> void:
	match new_hero:
		Genum.Classes.WARRIOR:
			characters.play("warrior")
			direction_arrow.play("arrows",0)
			direction_arrow.set_frame_and_progress(0,0)
		Genum.Classes.ROGUE:
			characters.play("rogue")
			if !up :
				direction_arrow.play("arrows",0)
				direction_arrow.set_frame_and_progress(1,0)
			else :
				direction_arrow.play("arrows",0)
				direction_arrow.set_frame_and_progress(4,0)
		Genum.Classes.ARCHER:
			characters.play("archer")
			if !up :
				direction_arrow.play("arrows",0)
				direction_arrow.set_frame_and_progress(2,0)
			else :
				direction_arrow.play("arrows",0)
				direction_arrow.set_frame_and_progress(3,0)

func _on_lever_button_pressed() -> void:
	GameGlobalEvents.use_lever.emit()
	lever.play("default")
	SoundManager.play_sound(Sounds.sfx_lever, "SFX")
	arrow.visible = false
	lever_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_info_button_pressed() -> void:
	SoundManager.play_sound(Sounds.sfx_button, "SFX")
	var tween = get_tree().create_tween()
	if sidePanel.offset.x > 0:
		disable_buttons()
		tween.tween_property(sidePanel, "offset:x", 0, .5)
		tween.play()
		await tween.finished
		enable_buttons()
	elif sidePanel.offset.x == 0:
		disable_buttons()
		tween.tween_property(sidePanel, "offset:x", 70, .5)
		tween.play()
		await tween.finished
		enable_buttons()


func _on_swap_button_pressed() -> void:
	SoundManager.play_sound(Sounds.sfx_button, "SFX")
	GameGlobalEvents.switch_hero.emit()
	

func _on_lever_animation_finished() -> void:
	arrow.visible = true

func _on_options_button_pressed() -> void:
	SoundManager.play_sound(Sounds.sfx_button, "SFX")
	var tween = get_tree().create_tween()
	match menuOpen:
		false: 
			tween.tween_property(optionsMenu, "position:y", 70,.25)
			tween.play()
			menuOpen = true
			disable_buttons()
			arrow.visible = false
			await tween.finished
			optionsButton.disabled = false
			get_tree().paused = true
		true: 
			tween.tween_property(optionsMenu, "position:y", 180,.25)
			tween.play()
			disable_buttons()
			get_tree().paused = false
			await tween.finished
			optionsMenu.position.y = -81
			menuOpen = false
			enable_buttons()
			arrow.visible = true
			
			
func _on_reel_finished() -> void:
	enable_buttons()
	lever_button.mouse_filter = Control.MOUSE_FILTER_STOP
