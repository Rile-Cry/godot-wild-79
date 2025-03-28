extends CanvasLayer

@export var label : Label
@export var restart_container : PanelContainer
@export var restart_text : TextEdit
@export var restart_button : Button
@export var apply_bonus_button : Button
@export var bonus_type_selector : OptionButton
@export var bonus_level_selector : OptionButton


var can_debug := false

func  _ready() -> void:
	for bType in Genum.BonusType :
		bonus_type_selector.add_item(str(bType))
	for bLvl in Genum.BonusLevel :
		bonus_level_selector.add_item(str(bLvl))
		print(str(bLvl))
		

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_toggle"):
		if not can_debug:
			can_debug = true
			label.show()
		else:
			can_debug = false
			label.hide()
	
	if can_debug:
		if event.is_action_pressed("restart_run"):
			if restart_container:
				restart_container.show()
		
		if restart_container.visible:
			if event.is_action_pressed("ui_cancel"):
				restart_text.text = restart_text.text.left(3)
				restart_text.editable = true

func _on_text_changed() -> void:
	if restart_text.text.length() > 4:
		restart_text.text = restart_text.text.left(4)
		restart_text.editable = false

func _on_restart_pressed() -> void:
	if restart_text.text.length() > 0:
		GameGlobalEvents.debug_newseed.emit(restart_text.text.to_int())
	else:
		GameGlobalEvents.debug_restart.emit()


func _on_apply_bonus_button_pressed() -> void:
	
	#TODO: apply selected bonus and emit signal.
	
	
	pass # Replace with function body.
