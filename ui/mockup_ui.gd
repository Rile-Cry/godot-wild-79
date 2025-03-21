extends CanvasLayer
@onready var lever = $Lever
@onready var leverPull = $LeverPull
@onready var sidePanel = $SidePanel

func _on_lever_button_pressed() -> void:
	lever.play("default")
	leverPull.play()


func _on_info_button_pressed() -> void:
	var tween = get_tree().create_tween()
	if sidePanel.offset.x > 0:
		tween.tween_property(sidePanel, "offset:x", 0, .5)
		tween.play()
	elif sidePanel.offset.x == 0:
		tween.tween_property(sidePanel, "offset:x", 70, .5)
		tween.play()
