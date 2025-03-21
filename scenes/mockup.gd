extends Node2D

@onready var lever = $Background/SlotMachineBase/Lever
@onready var sidePanel = $SidePanel


func _on_button_pressed() -> void:
	lever.play("default")
	

# TODO make it so you can't press the info button while the side panel is moving
func _on_info_button_pressed() -> void:
	var tween_right = get_tree().create_tween()
	var tween_left = get_tree().create_tween()
	if sidePanel.position.x > 0:
		tween_left.tween_property(sidePanel, "position:x", 0, .35)
		tween_left.play()
		
	elif sidePanel.position.x == 0:
		tween_right.tween_property(sidePanel, "position:x", 70, .35)
		tween_right.play()
			
			
			
		
	
