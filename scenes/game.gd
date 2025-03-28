extends Node

@export var reels : Array[Node2D]
@export var position_highlight : Sprite2D
@export var position_markers : Array[Marker2D]


var cards_collected : Array[Vector2i]
var current_class := Genum.Classes.WARRIOR
var up := false
var state := Genum.PlayingState.LOADED

func _ready() -> void:
	GameGlobalEvents.game_start.connect(_first_round)
	GameGlobalEvents.bonus_level_sound.connect(play_bonus_sound)
	GameGlobalEvents.use_lever.connect(_on_lever_used)
	GameGlobalEvents.switch_hero.connect(_on_hero_switched)
	GameGlobalEvents.toggle_direction.connect(_on_direction_toggled)
	
	

	SoundManager.play_music(Sounds.music_menu, 0.0, "Music")
	
	
	
	

func play_bonus_sound(level:Genum.BonusLevel):
	match level:
		Genum.BonusLevel.ONE:
			SoundManager.play_sound(Sounds.sfx_lvl1, "SFX")
		Genum.BonusLevel.TWO:
			SoundManager.play_sound_with_pitch(Sounds.sfx_lvl2,1.2, "SFX")
		Genum.BonusLevel.MAX:
			SoundManager.play_sound_with_pitch(Sounds.sfx_lvl3,1.0, "SFX")
		
func _first_round():
	_set_reel_ids()
	_update_reel_positions()
	
	if state == Genum.PlayingState.LOADED:
		state = Genum.PlayingState.TURN_ONE

func _set_reel_ids() -> void:
	var i : int = 1
	for reel in reels:
		reel.reel_id = i
		i += 1

func _update_reel_positions() -> void:
	SoundManager.play_sound(Sounds.sfx_reel_spin, "SFX")
	
	if state == Genum.PlayingState.TURN_ONE:
		state = Genum.PlayingState.PLAYING
	
	var current_position := MapManager.map_position
	for reel in reels:
		reel.update_reel(current_position, state)
	
	_update_highlight()

func _on_lever_used() -> void:
	MapManager.move_current_position(current_class, up)
	_update_reel_positions()
	

func _on_hero_switched() -> void:
	match(current_class):
		Genum.Classes.WARRIOR:
			current_class = Genum.Classes.ROGUE
			SoundManager.play_sound(Sounds.sfx_rogue, "SFX")
		Genum.Classes.ROGUE:
			if up:
				current_class = Genum.Classes.WARRIOR
				SoundManager.play_sound(Sounds.sfx_warrior, "SFX")
				up = false
			else:
				current_class = Genum.Classes.ARCHER
				SoundManager.play_sound(Sounds.sfx_archer, "SFX")
		Genum.Classes.ARCHER:
			if up:
				current_class = Genum.Classes.ROGUE
				SoundManager.play_sound(Sounds.sfx_rogue, "SFX")
			else:
				current_class = Genum.Classes.ARCHER
				SoundManager.play_sound(Sounds.sfx_archer, "SFX")
				up = true
	
	_update_highlight()
	$UI.change_hero(current_class,up)

func _update_highlight() -> void:
	if state == Genum.PlayingState.PLAYING:
		position_highlight.position = position_markers[1].position
		reels[2].update_highlight(current_class, up)
	else:
		position_highlight.position = position_markers[0].position
		reels[1].update_highlight(current_class, up)
	

func _on_direction_toggled() -> void:
	up = not up
	_update_highlight()

func _on_reel_5_reel_stopped() -> void:
	SoundManager.stop_sound(Sounds.sfx_reel_spin)
	SoundManager.stop_sound(Sounds.sfx_reel_jingle)
	$SlotMachine/Lights.stop()
	$SlotMachine/Lights.speed_scale = 1.0
	$SlotMachine/Lights.play("default")
	#SoundManager.stop(AK.EVENTS.REELSPIN)
	GameGlobalEvents.reel_over.emit()

func _on_reel_5_reel_started() -> void:
	SoundManager.play_sound(Sounds.sfx_reel_spin, "SFX")
	SoundManager.play_sound(Sounds.sfx_reel_jingle, "SFX")
	$SlotMachine/Lights.stop()
	$SlotMachine/Lights.speed_scale = 7.8
	$SlotMachine/Lights.play("default")
	#SoundManager.play(AK.EVENTS.REELSPIN)

func _bonus_update(bonus_id:int) -> void:
	pass
