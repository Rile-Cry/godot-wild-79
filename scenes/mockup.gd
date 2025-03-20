extends Node2D

@onready var lever = $Background/SlotMachineBase/Lever
@onready var sidePanel = $SidePanel


func _on_button_pressed() -> void:
	lever.play("default")
	


func _on_info_button_pressed() -> void:
	var tween = get_tree().create_tween()
	if sidePanel.position.x > 0 and !tween.is_running():
		tween.tween_property(sidePanel, "position:x", 0, .5)
		tween.play()
		tween.stop()
	elif sidePanel.position.x == 0 and !tween.is_running():
		tween.tween_property(sidePanel, "position:x", 70, .5)
		tween.play()
		tween.stop()
			
			
			
		
	
