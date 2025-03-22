extends CanvasLayer
@onready var lever = $Lever
@onready var leverPull = $LeverPull
@onready var sidePanel = $SidePanel
@onready var characters = $LowerButtonPanel/Buttons/Characters
@onready var arrow = $Arrow

var swap_counter = 1

func _on_lever_button_pressed() -> void:
	GameGlobalEvents.use_lever.emit()
	lever.play("default")
	leverPull.play()
	arrow.visible = false


func _on_info_button_pressed() -> void:
	var tween = get_tree().create_tween()
	if sidePanel.offset.x > 0:
		tween.tween_property(sidePanel, "offset:x", 0, .5)
		tween.play()
	elif sidePanel.offset.x == 0:
		tween.tween_property(sidePanel, "offset:x", 70, .5)
		tween.play()


func _on_swap_button_pressed() -> void:
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
	GameGlobalEvents.toggle_direction.emit()


func _on_lever_animation_finished() -> void:
	arrow.visible = true
