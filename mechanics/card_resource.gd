class_name CardResource extends Resource

@export var card_name : StringName = "Card Name" ## The name for the card.
@export var card_texture_position : Vector2i ## The texture of the card.
## What type of card it is / This will also double as the Y coordinate of the spritesheet
@export var card_type : Genum.CardType
@export var card_id : int = 0
@export var card_weight : float = 1.0 ## Default card weight for mapping.
@export var card_weight_coefficient : float = 1.0 ## The Growth rate for card weight away from [0, 8]
@export var card_value : int
