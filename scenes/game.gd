extends Node

@export var reels : Array[Node2D]
@export var position_highlight : Sprite2D
@export var position_markers : Array[Marker2D]
var current_class := Genum.Classes.WARRIOR
var up := false
var loaded := false
var turn_one := true

func _ready() -> void:
	_set_reel_ids()
	_update_reel_positions()
	
	GameGlobalEvents.use_lever.connect(_on_lever_used)
	GameGlobalEvents.switch_hero.connect(_on_hero_switched)
	GameGlobalEvents.toggle_direction.connect(_on_direction_toggled)
	
	if not loaded:
		loaded = true

func _set_reel_ids() -> void:
	var i : int = 0
	for reel in reels:
		reel.reel_id = i
		i += 1

func _update_reel_positions() -> void:
	var i : int = 0
	if not turn_one:
		i = -1
	
	var current_position := MapManager.map_position
	for reel in reels:
		reel.update_reel(current_position + Vector2i(i, 0))
		i += 1
	
	if loaded:
		turn_one = false
	
	_update_highlight()

func _on_lever_used() -> void:
	MapManager.move_current_position(current_class, up)
	_update_reel_positions()

func _on_hero_switched() -> void:
	match(current_class):
		Genum.Classes.WARRIOR:
			current_class = Genum.Classes.ROGUE
		Genum.Classes.ROGUE:
			current_class = Genum.Classes.ARCHER
		Genum.Classes.ARCHER:
			current_class = Genum.Classes.WARRIOR
	
	_update_highlight()

func _update_highlight() -> void:
	if turn_one:
		position_highlight.position = position_markers[0].position
		reels[1].update_highlight(current_class, up)
	else:
		position_highlight.position = position_markers[1].position
		reels[2].update_highlight(current_class, up)

func _on_direction_toggled() -> void:
	up = not up
	_update_highlight()

func _on_reel_5_reel_stopped() -> void:
	$ReelSpin.playing = false
	$SlotMachine/Lights.stop()
	$SlotMachine/Lights.speed_scale = 1.0
	$SlotMachine/Lights.play("default")
	SoundManager.stop_sfx(1)
	GameGlobalEvents.reel_over.emit()

func _on_reel_5_reel_started() -> void:
	$ReelSpin.playing = true
	$SlotMachine/Lights.stop()
	$SlotMachine/Lights.speed_scale = 7.8
	$SlotMachine/Lights.play("default")
	SoundManager.play_sfx("reelSpin", 1)
