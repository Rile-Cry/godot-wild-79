class_name CardResource extends Resource

## List of CARD WEIGHTS from 3/18 - Jintachi
#	1.0		***************************
#	0.9		1,2,3,4,5,6,8,9
#	0.8		
#	0.7		
#	0.6		7
#	0.5		
#	0.4		BAR
#   0.3		TREASURE
#   0.2		BOMB
#   0.1		MULTIPLY
#	0.0		***************************

## TODO: Flesh out changes of card types
# OLD ENUM
# enum CardType {
	#BASE,
	#TREASURE,
	#MULTIPLY,
	#BOMB,
	#BAR
# }

enum CardType {
	NUMBER,
	EFFECT,
	EVENT
}

@export var card_name : StringName = "Card Name" ## The name for the card.
@export var card_texture_position : Vector2i ## The texture of the card.
## What type of card it is / This will also double as the Y coordinate of the spritesheet
@export var card_type : CardType
@export var card_id : int = 0
@export var card_weight : float = 1.0 ## Default card weight for mapping.
