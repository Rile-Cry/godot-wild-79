extends CanvasLayer
@onready var lever = $Lever
@onready var leverPull = $LeverPull
@onready var sidePanel = $SidePanel
@onready var characters = $LowerButtonPanel/Buttons/Characters

var swap_counter = 1

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


func _on_swap_button_pressed() -> void:
	print(swap_counter)
	match swap_counter:
		0:
			characters.play("warrior")
		1:
			characters.play("archer")
		2:
			characters.play("rogue")	
	swap_counter += 1
	if swap_counter > 2:
		swap_counter = 0
	
