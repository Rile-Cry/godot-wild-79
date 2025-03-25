extends NinePatchRect
	

func _on_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", -50, .2)
	tween.play()
	await tween.finished
	var tween1 = get_tree().create_tween()
	SoundManager.play_music(Sounds.music_low, .75, "Music")
	tween1.tween_property(self, "position:y", 200, .75)
	tween1.play()
	await tween1.finished
	
	#SoundManager.soundtrack_crossfade()
	#SoundManager._set_phase(AK.STATES.PHASE.STATE.GAMEPLAY)
	#SoundManager._set_intensity(AK.STATES.INTENSITY.STATE.LOW)
	GameGlobalEvents.game_start.emit()
