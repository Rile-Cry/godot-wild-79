extends Node2D


# Dialogue vars
@export var dialogue_resource: Dialogue

func _ready() -> void:
	SoundManager.play_music(Sounds.music_shop, 1.0, "Music")
