extends CanvasLayer

@export var label : Label
@export var restart_container : PanelContainer
@export var restart_text : TextEdit
@export var restart_button : Button
var can_debug := false

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
