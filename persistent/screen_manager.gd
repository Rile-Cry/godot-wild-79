extends Node

const AspectRatio := Vector2i(16, 9)

var resolutions : Array[Vector2i] = [
	Vector2i(320, 180),
	Vector2i(400, 224),
	Vector2i(640, 360),
	Vector2i(960, 540),
	Vector2i(1280, 720),
	Vector2i(1280, 800),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160),
	Vector2i(5120, 2880),
	Vector2i(7680, 4320),
]
var current_resolution : int

func _enter_tree() -> void:
	get_tree().root.size_changed.connect(_on_size_changed)
	current_resolution = resolutions.find(DisplayServer.window_get_size_with_decorations())

#region Resolution Getters
func get_resolutions(use_computer_screen_limit: bool = false) -> Array[Vector2i]:
	if use_computer_screen_limit:
		return resolutions.filter(_filter_by_screen_size_limit)
	
	return resolutions

func _filter_by_screen_size_limit(screen_size: Vector2i) -> bool:
	return screen_size <= HardwareDetector.computer_screen_size
#endregion

func center_window_position(viewport : Viewport = get_viewport()) -> void:
	var windowSize := viewport.get_window().get_size_with_decorations()
	
	viewport.get_window().position = monitor_screen_center() - windowSize / 2

## Current screen center of the viewport in the world
func screen_center() -> Vector2i:
	return get_viewport().get_visible_rect().size / 2

func monitor_screen_center() -> Vector2i:
	return DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2

func change_size() -> void:
	current_resolution += 1
	if current_resolution >= resolutions.size():
		current_resolution = 0
	DisplayServer.window_set_size(resolutions.get(current_resolution))

#region Signal Callbacks
func _on_size_changed() -> void:
	center_window_position()
#endregion
