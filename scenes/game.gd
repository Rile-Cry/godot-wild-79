extends Node

enum Classes {
	WARRIOR,
	ROGUE,
	ARCHER
}

@export var reels : Array[Node2D]
var current_class := Classes.WARRIOR
var up := false
var turn_one := true

func _ready() -> void:
	_set_reel_ids()
	_update_reel_positions()
	_update_highlight()
	
	GameGlobalEvents.use_lever.connect(_on_lever_used)
	GameGlobalEvents.switch_hero.connect(_on_hero_switched)
	GameGlobalEvents.toggle_direction.connect(_on_direction_toggled)

func _set_reel_ids() -> void:
	var i : int = 0
	for reel in reels:
		reel.reel_id = i
		i += 1

func _update_reel_positions() -> void:
	var i : int = 0
	var current_position := MapManager.map_position
	for reel in reels:
		reel.update_reel(current_position + Vector2i(i, 0))
		i += 1

func _on_lever_used() -> void:
	if up:
		MapManager.map_position += Vector2i(1, -current_class)
	else:
		MapManager.map_position += Vector2i(1, current_class)
	
	_update_reel_positions()

func _on_hero_switched() -> void:
	match(current_class):
		Classes.WARRIOR:
			current_class = Classes.ROGUE
		Classes.ROGUE:
			current_class = Classes.ARCHER
		Classes.ARCHER:
			current_class = Classes.WARRIOR
	
	_update_highlight()

func _update_highlight() -> void:
	reels[1].update_highlight(current_class, up)

func _on_direction_toggled() -> void:
	up = not up
	_update_highlight()


func _on_reel_5_reel_stopped() -> void:
	$ReelSpin.playing = false
	$SlotMachine/Lights.stop()
	$SlotMachine/Lights.speed_scale = 1.0
	$SlotMachine/Lights.play("default")


func _on_reel_5_reel_started() -> void:
	$ReelSpin.playing = true
	$SlotMachine/Lights.stop()
	$SlotMachine/Lights.speed_scale = 7.8
	$SlotMachine/Lights.play("default")
