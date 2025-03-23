extends CanvasLayer

@onready var lever = $Lever
@onready var lever_button : Button = $Lever/LeverButton
@onready var leverPull = $Sounds/LeverPull
@onready var buttonClick = $Sounds/ButtonClick
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

var swap_counter = 1
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

func _on_lever_button_pressed() -> void:
	GameGlobalEvents.use_lever.emit()
	lever.play("default")
	Wwise.post_event_id(AK.EVENTS.LEVERPULL, self)
	#leverPull.play()
	arrow.visible = false
	lever_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_info_button_pressed() -> void:
	buttonClick.play()
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
	buttonClick.play()
	match swap_counter:
		0:
			characters.play("warrior")
		1:
			characters.play("rogue")	
		2:
			characters.play("archer")
	swap_counter += 1
	if swap_counter > 2:
		swap_counter = 0
	
	GameGlobalEvents.switch_hero.emit()


func _on_up_down_button_pressed() -> void:
	buttonClick.play()
	GameGlobalEvents.toggle_direction.emit()


func _on_lever_animation_finished() -> void:
	arrow.visible = true

func _on_options_button_pressed() -> void:
	buttonClick.play()
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
