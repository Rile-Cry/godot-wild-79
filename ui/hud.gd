extends CanvasLayer

@export var actions_container : PanelContainer
@export var anim_player : AnimationPlayer

func _ready() -> void:
	add_to_group("ui", true)
	
	anim_player.play("startup")
