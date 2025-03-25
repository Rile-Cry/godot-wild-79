extends Control

@export var score_label : RichTextLabel
@export var pulls_label : RichTextLabel
var dollar : String = "[color=green]$[/color]"

func _ready() -> void:
	GameGlobalEvents.changed_stats.connect(_on_score_changed)
	GameGlobalEvents.changed_stats.connect(_on_pull_changed)
	
	score_label.text = dollar + "0"

func _on_score_changed() -> void:
	score_label.text = dollar + "%s" % Global.get_var(Genum.Vars.SCORE)
	
func _on_pull_changed() -> void:
	var pull_count = Global.get_var(Genum.Vars.PULLS)
	if pull_count >= 6 :
		pulls_label.text = "[color=green]" + "%s" % Global.get_var(Genum.Vars.PULLS) + "[/color] Pulls Remain" 
	elif pull_count <= 5 and pull_count >= 3 :
		SoundManager.play_music(Sounds.music_med, 0.5, "Music")
		pulls_label.text = "[color=yellow]" + "%s" % Global.get_var(Genum.Vars.PULLS) + "[/color] Pulls Remain"
	elif pull_count == 3 : 
		SoundManager.play_music(Sounds.music_high, 0.5, "Music")
		pulls_label.text = "[color=orange]" + "%s" % Global.get_var(Genum.Vars.PULLS) + "[/color] Pulls Remain"
	elif pull_count == 2 :
		pulls_label.text = "[color=red]" + "%s" % Global.get_var(Genum.Vars.PULLS) + "[/color] Pull Remains"
	elif pull_count == 1 :
		pulls_label.text = "[color=red]Last Pull, Make It Count![/color]"
