extends CanvasLayer
@onready var lever = $Lever

func _on_lever_button_pressed() -> void:
	lever.play("default")
