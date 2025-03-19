class_name CardResource extends Resource

## List of CARD WEIGHTS from 3/18 - Jintachi
#	1.0		1,2,3,4,5,6
#	0.9		8, 9
#	0.8		
#	0.7		
#	0.6		7
#	0.5		
#	0.4		BAR
#   0.3		TREASURE
#   0.2		BOMB
#   0.1		

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
@export var card_weight : float = 1.0 ## Default card weight for mapping.
