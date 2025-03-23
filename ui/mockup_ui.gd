extends CanvasLayer

@onready var lever = $Lever
@onready var lever_button : Button = $Lever/LeverButton
@onready var sidePanel = $SidePanel
@onready var characters = $LowerButtonPanel/Buttons/Characters
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
	disable_buttons()
	
func disable_buttons():
	infoButton.disabled = true
	upDownButton.disabled = true
	swapButton.disabled = true
	leverButton.disabled = true
	optionsButton = true

func enable_buttons():
	infoButton.disabled = false
	upDownButton.disabled = false
	swapButton.disabled = false
	leverButton.disabled = false
	optionsButton = false

func change_hero(new_hero: Genum.Classes) -> void:
	match new_hero:
		Genum.Classes.WARRIOR:
			characters.play("warrior")
		Genum.Classes.ROGUE:
			characters.play("rogue")	
		Genum.Classes.ARCHER:
			characters.play("archer")

func _on_lever_button_pressed() -> void:
	GameGlobalEvents.use_lever.emit()
	lever.play("default")
	Wwise.post_event_id(AK.EVENTS.LEVERPULL, self)
	#leverPull.play()
	arrow.visible = false
	lever_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_info_button_pressed() -> void:
	SoundManager.play(AK.EVENTS.BUTTON)
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
	SoundManager.play(AK.EVENTS.BUTTON)
	GameGlobalEvents.switch_hero.emit()
	


func _on_up_down_button_pressed() -> void:
	SoundManager.play(AK.EVENTS.BUTTON)
	GameGlobalEvents.toggle_direction.emit()


func _on_lever_animation_finished() -> void:
	arrow.visible = true

func _on_options_button_pressed() -> void:
	SoundManager.play(AK.EVENTS.BUTTON)
	var tween = get_tree().create_tween()
	match menuOpen:
		false: 
			tween.tween_property(optionsMenu, "position:y", 70,.25)
			tween.play()
			menuOpen = true
			disable_buttons()
			arrow.visible = false
			await tween.finished
			get_tree().paused = true
		true: 
			tween.tween_property(optionsMenu, "position:y", 180,.25)
			tween.play()
			get_tree().paused = false
			await tween.finished
			optionsMenu.position.y = -81
			menuOpen = false
			enable_buttons()
			arrow.visible = true
			
			
func _on_reel_finished() -> void:
	enable_buttons()
	lever_button.mouse_filter = Control.MOUSE_FILTER_STOP
