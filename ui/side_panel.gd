extends Control

#@export var tab_bar : TabBar
@export var tab_container : TabContainer
@export var combo_box : TabBar
@export var guide_box : TabBar

func _ready() -> void:
	tab_container.tab_clicked.connect(tab_swap)
	combo_box.tab_clicked.connect(tab_swap)
	guide_box.tab_clicked.connect(tab_swap)


func tab_swap(tab: int) -> void:
	match tab:
		0: tab_container.current_tab = 0
		1: tab_container.current_tab = 1
	pass # Replace with function body.
