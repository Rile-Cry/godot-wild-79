extends Control

@export var label : RichTextLabel
var dollar : String = "[color=green]$[/color]"

func _ready() -> void:
	GameGlobalEvents.changed_score.connect(_on_score_changed)
	
	label.text = dollar + "0"

func _on_score_changed() -> void:
	label.text = dollar + "%s" % Global.get_var(Genum.Vars.SCORE)
