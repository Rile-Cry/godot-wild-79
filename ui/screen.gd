extends Control

@export var score_label : RichTextLabel
@export var pulls_label : RichTextLabel

@export var recent_one : TextureRect
@export var recent_two : TextureRect
@export var recent_three : TextureRect
var card_one_stored :bool = false
var card_two_stored :bool = false
var card_three_stored :bool = false
@export var atlas : AtlasTexture


var dollar : String = "[color=green]$[/color]"

func _ready() -> void:
	GameGlobalEvents.changed_stats.connect(_on_score_changed)
	GameGlobalEvents.changed_stats.connect(_on_pull_changed)
	DeckManager.card_collected.connect(_card_history)
	for c in $"HBoxContainer/VBoxContainer/HFlowContainer/Recent Cards".get_children() :
		c.visible = false
	
	#atlas.resource_local_to_scene = true
	
	score_label.text = dollar + "0"

func _on_score_changed() -> void:
	score_label.text = dollar + "%s" % Global.get_var(Genum.Vars.SCORE)
	
func _card_history(card:CardResource) -> void:
	var atlas_region = Rect2(card.card_texture_position.x*28,card.card_texture_position.y*16,28,16)
	var temp_texture = AtlasTexture.new()
	#temp_texture.resource_local_to_scene = true
	temp_texture = atlas.duplicate(true)
	temp_texture.region = atlas_region
	if !card_one_stored:
		recent_one.texture = temp_texture
		recent_one.visible = true
		card_one_stored = true
	elif !card_two_stored and card_one_stored :
		recent_two.texture = temp_texture
		recent_two.visible = true
		card_two_stored = true
	elif card_one_stored and card_two_stored and !card_three_stored:
		recent_three.texture = temp_texture
		recent_three.visible = true
		card_three_stored = true
	elif card_three_stored :
		recent_one.texture = recent_two.texture
		recent_two.texture = recent_three.texture
		recent_three.texture = temp_texture
	pass

func _on_pull_changed() -> void:
	var pull_count = Global.get_var(Genum.Vars.PULLS)
	if pull_count >= 6 :
		pulls_label.text = "[color=green]" + "%s" % Global.get_var(Genum.Vars.PULLS) + "[/color] Pulls Remain" 
	elif pull_count <= 5 and pull_count >= 3 :
		pulls_label.text = "[color=yellow]" + "%s" % Global.get_var(Genum.Vars.PULLS) + "[/color] Pulls Remain"
	elif pull_count == 3 : 
		pulls_label.text = "[color=orange]" + "%s" % Global.get_var(Genum.Vars.PULLS) + "[/color] Pulls Remain"
	elif pull_count == 2 :
		pulls_label.text = "[color=red]" + "%s" % Global.get_var(Genum.Vars.PULLS) + "[/color] Pull Remains"
	elif pull_count == 1 :
		pulls_label.text = "[color=red]Last Pull, Make It Count![/color]"
