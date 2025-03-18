class_name CardResource extends Resource

enum CardType {
	BASE,
	BOMB
}

@export var card_name : StringName = "Card Name" ## The name for the card.
@export var texture : Texture2D ## The texture of the card.
## What type of card it is
@export var card_type : CardType
