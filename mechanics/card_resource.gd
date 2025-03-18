class_name CardResource extends Resource

enum CardType {
	BASE,
	TREASURE,
	MULTIPLY,
	BOMB,
	BAR
}

@export var card_name : StringName = "Card Name" ## The name for the card.
@export var card_texture_position : int = 0 ## The texture of the card.
## What type of card it is
@export var card_type : CardType
