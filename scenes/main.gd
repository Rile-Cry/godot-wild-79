extends Node

@export var game_scene : PackedScene

func _ready() -> void:
	var game = game_scene.instantiate()
	add_child(game)
	
	GameGlobalEvents.new_run.connect(_on_new_start)

func _on_new_start() -> void:
	var seed = Global.rng.randi_range(0, 9999)
	var game = get_child(0)
	remove_child(game)
	game.queue_free()
	
	Global.new_run(seed)
	await GameGlobalEvents.generation_complete
	
	game = game_scene.instantiate()
	add_child(game)
