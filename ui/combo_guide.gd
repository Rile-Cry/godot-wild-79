extends VSplitContainer

@export var combo_list : VBoxContainer
@export var detailBox : RichTextLabel
@export var combo_ItemList :ItemList
@export var combo_text_file:JSON
@onready var loader = JsonLoader.new()
@onready var loaded_bonus_data = {}


var combos:Array

var details : Dictionary[Genum.BonusType,String]

func _ready() -> void:
	
	
	
	for rtl in combo_list.get_children() :
		combo_ItemList.add_item(rtl.text,null,true)

	for item in combo_ItemList.item_count :
		combo_ItemList.set_item_tooltip_enabled(item,false)
	
	
	loaded_bonus_data = loader.load_from_json(combo_text_file.resource_path)


func _on_item_list_item_selected(index: int) -> void:
	
	var key:String = combo_ItemList.get_item_text(index)
	
	detailBox.text = loaded_bonus_data[key]
	if Global.debug_active :
		print(loaded_bonus_data[key])
	pass # Replace with function body.
