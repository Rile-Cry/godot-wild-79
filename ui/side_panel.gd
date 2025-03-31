extends Control

@export var tab_bar : TabBar
@export var tab_container : TabContainer
@export var combo_box : VBoxContainer
@export var guide_box : HBoxContainer

#func _ready() -> void:
	#combo_box.visible = true
	#guide_box.visible = false
	##tab_container.set_tab_hidden(0,true)



#func _on_tab_container_tab_selected(tab: int) -> void:
	#match tab:
		#0 :
			#combo_box.visible = true
			#guide_box.visible = false
		#1 :
			#combo_box.visible = false
			#guide_box.visible = true
			#
	#pass # Replace with function body.
