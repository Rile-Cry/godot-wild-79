extends Node

func _ready() -> void:
	GameGlobalEvents.post_event.connect(_on_event_posted)

func _on_event_posted(event: WwiseEvent) -> void:
	event.post(self)
