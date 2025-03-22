extends CanvasLayer
@onready var lever = $Lever
@onready var lever_button : Button = $Lever/LeverButton
@onready var leverPull = $Sounds/LeverPull
@onready var buttonClick = $Sounds/ButtonClick
@onready var sidePanel = $SidePanel
@onready var characters = $LowerButtonPanel/Buttons/Characters
@onready var arrow = $Arrow
@onready var optionsMenu = $OptionsMenu

var swap_counter = 1
var menuOpen = false

func _ready() -> void:
	GameGlobalEvents.reel_over.connect(_on_reel_finished)

func _on_lever_button_pressed() -> void:
	GameGlobalEvents.use_lever.emit()
	lever.play("default")
	leverPull.play()
	arrow.visible = false
	lever_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_info_button_pressed() -> void:
	buttonClick.play()
	var tween = get_tree().create_tween()
	if sidePanel.offset.x > 0:
		tween.tween_property(sidePanel, "offset:x", 0, .5)
		tween.play()
	elif sidePanel.offset.x == 0:
		tween.tween_property(sidePanel, "offset:x", 70, .5)
		tween.play()


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
			tween.tween_property(optionsMenu, "scale", Vector2(1,1),.25)
			tween.play()
			menuOpen = true
		true: 
			tween.tween_property(optionsMenu, "scale", Vector2(0,0),.25)
			tween.play()
			menuOpen = false
			
func _on_reel_finished() -> void:
	lever_button.mouse_filter = Control.MOUSE_FILTER_STOP
