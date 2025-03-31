extends HBoxContainer

@export var combo_list : VBoxContainer
@export var detailBox : RichTextLabel

var combos:Array

var details : Dictionary[Genum.BonusType,String]

#func _ready() -> void:
#
	#for bonus in combo_list.get_child_count() :
		#combos.append(combo_list.get_child(bonus))
#

#func _on_list_of_combos_gui_input(event: InputEvent) -> void:
	#
	#if event == FOCUS_CLICK :
		#
	#pass # Replace with function body.
