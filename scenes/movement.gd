extends Node


## Classes for the Y modifier of the movement component
enum classes {
	WARRIOR = 0,
	ROGUE = 1,
	ARCHER = 2
}

## TODO: 
# Needed DATA
# Current Coordinates, Active Character,if not war, add up / down amount to movement vector
var player_coords:=Vector2i(1,0)
var active_class:= 0 as classes ## start as the warrior





@export var card_scene : PackedScene
var screen_offset : Vector2i
var y_gap := 17 as int
var x_gap := 30 as int

var half_map:= MapManager.map_size.y/2 as int



@export var centerCard:=Marker2D

func _ready() -> void:
	screen_offset = get_tree().root.get_size_with_decorations()
	screen_offset /= MapManager.map_size
	
	centerCard.position.y = half_map*y_gap
	
	var pos := Vector2i.ZERO
	for x in MapManager.current_map:
		pos.y = 0
		for y in x:
			var card : Node2D = card_scene.instantiate()
			card.card_frame = y
			add_child(card)
			card.position = Vector2(pos.x * x_gap, pos.y * y_gap)
			card.z_index = $SlotMachineBase.z_index-1
			pos.y += 1
		pos.x += 1
	

## TODO: Highlighting and focusing the nodes we want to move to.
func player_move() -> void:
	
	
	
	
	return
	
## TODO MAP SHIFTING
# get distance to edge (top/bottom) of slot machine. if +/- 3 from (CURRENT MIDDLE LINE.y) slide map +/-2 intended Y
# some sort of halo/highlight on the proposed movement
# Sliding all reels x-1 positionally
