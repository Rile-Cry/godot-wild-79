extends NinePatchRect
	

func _on_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, .5)
	tween.play()
	await tween.finished
	GameGlobalEvents.game_start.emit()
