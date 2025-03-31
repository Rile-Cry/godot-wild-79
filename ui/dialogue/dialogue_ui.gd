extends Control


@onready var nine_patch_rect: NinePatchRect = $CanvasLayer/NinePatchRect
@onready var dialogue_text: Label = $CanvasLayer/NinePatchRect/DialogueBox/DialogueText
@onready var dialogue_options: HBoxContainer = $CanvasLayer/NinePatchRect/DialogueBox/DialogueOptions

func _ready() -> void:
	hide_dialogue()
	
# Show dialogue box
func show_dialogue(text, options):
	nine_patch_rect.visible = true
	
	# Populate data
	dialogue_text.text = text
	
	# Remove existing options
	for option in dialogue_options.get_children():
		dialogue_options.remove_child(option)
	
	# Populate options
	for option in options.keys():
		var button = Button.new()
		button.text = option
		button.add_theme_font_size_override("font_size", 8)
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.pressed.connect(_on_option_selected.bind(option))
		dialogue_options.add_child(button)

# Hide dialogue
func hide_dialogue():
	nine_patch_rect.visible = false

# Handle response selection
func _on_option_selected(option):
	get_parent().handle_dialogue_option(option)
