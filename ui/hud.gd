extends CanvasLayer

signal move_down
signal move_right
signal move_up

@export var actions_container : PanelContainer

func _ready() -> void:
	add_to_group("ui", true)

func _on_actions_button_pressed() -> void:
	actions_container.show()

func _on_close_actions_pressed() -> void:
	actions_container.hide()

func _on_down_button_pressed() -> void:
	move_down.emit()

func _on_right_button_pressed() -> void:
	move_right.emit()

func _on_up_button_pressed() -> void:
	move_down.emit()
