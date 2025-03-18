class_name HardwareDetector

static var engine_version : String = "Godot %s" % Engine.get_version_info().string
static var device : String = OS.get_model_name()
static var platform : String = OS.get_name()
static var distribution_name : String = OS.get_distribution_name()
static var video_adapter_name : String = RenderingServer.get_video_adapter_name()
static var processor_name : String = OS.get_processor_name()
static var processor_count : int = OS.get_processor_count()
static var usable_threads : int = processor_count * 2
static var computer_screen_size : Vector2i = DisplayServer.screen_get_size()
