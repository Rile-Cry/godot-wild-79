extends Node2D

@export var anim_player : AnimationPlayer
@export var card_list : Array[Node2D]
@export var reel_anim : Sprite2D
@export var reel_timer : Timer
@export var sfx_array : Array[StringName]
var card_offset : int = 1
var pos := Vector2i.ZERO
var reel_id : int = 0
var reel_time_delta : float = 0.5

signal reel_started
signal reel_stopped

func _ready() -> void:
	_update_cards()

func update_reel(new_pos: Vector2i, state: Genum.PlayingState) -> void:
	if state == Genum.PlayingState.PLAYING:
		pos = new_pos + Vector2i(reel_id - 2, 0)
	else:
		pos = new_pos + Vector2i(reel_id - 1, 0)
	_update_cards(state)
	play_animation()

func play_animation() -> void:
	reel_started.emit()
	_toggle_cards(true)
	reel_anim.show()
	anim_player.play("roll")
	reel_timer.start(1 + reel_id * reel_time_delta)
	await reel_timer.timeout
	anim_player.stop()
	reel_anim.hide()
	SoundManager.play_sfx(sfx_array[Global.rng.randi_range(0, sfx_array.size() - 1)])
	reel_stopped.emit()
	_toggle_cards(false)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position", Vector2(position.x, position.y + 8), 0.2)
	tween.tween_property(self, "position", Vector2(position.x, position.y), 0.2)
	

func update_highlight(hero: int, up: bool) -> void:
	var id : int = 0
	if up:
		id = card_list[3 - hero].card_id
	else:
		id = card_list[3 + hero].card_id
	
	get_tree().call_group("cards", "highlight", id)

func _toggle_cards(hid: bool = false) -> void:
	for card in card_list:
		if hid:
			card.hide()
		else:
			card.show()

func _update_cards(state: Genum.PlayingState = Genum.PlayingState.LOADED) -> void:
	var i : int = card_list.size()
	if i % 2 == 0:
		i = i / 2
	else:
		i = (i - 1) / 2
	i = -i
	for card in card_list:
		card.update_card(Vector2i(pos.x, pos.y + i))
		i += 1
