extends Node2D

@export var anim_player : AnimationPlayer
@export var cards : Array[Node2D]
var pos := Vector2i.ZERO

func _ready() -> void:
	_update_cards()

func update_reel(new_pos: Vector2i) -> void:
	pos = new_pos
	_update_cards()

func play_animation() -> void:
	anim_player.play("land_jiggle")

func _update_cards() -> void:
	var i : int = -ceil((cards.size()) / 2.)
	for card in cards:
		card.update_card(Vector2i(pos.x, pos.y + i))
		i += 1
