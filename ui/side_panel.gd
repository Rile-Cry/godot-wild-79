extends Control

@export var tab_bar : TabBar
@export var side_panel_container : TabContainer
@export var combo_box : VBoxContainer
@export var guide_box : VBoxContainer
@export var help_tree : Tree

#func _ready() -> void:
	#help_tree.add

func _on_tab_bar_tab_clicked(tab: int) -> void:
	
	match tab:
		0 :
			combo_box.visible = true
			guide_box.visible = false
		1 :
			combo_box.visible = false
			guide_box.visible = true
		
	
	pass # Replace with function body.


func _on_tab_container_tab_clicked(tab: int) -> void:
	
	match tab:
		0 :
			combo_box.visible = true
			guide_box.visible = false
		1 :
			combo_box.visible = false
			guide_box.visible = true
			
			
	pass # Replace with function body.
