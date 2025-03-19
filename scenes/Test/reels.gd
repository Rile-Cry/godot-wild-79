extends Node2D


var slots_array = []
var reels_array = []
var timer 
var is_spinning 
var end_locaiton
var spawn_location
# TODO: Maybe move each reel instead of array. otherwise a blank space occurs when moving to spawn pos

func _ready() -> void:
	reels_array = [%Apple_1, %Banana_1, %Cherry_1, %Apple_2, %Banana_2]
	slots_array = [%Slot_1, %Slot_2, %Slot_3, %Slot_4, %Slot_5]
	timer = %SpinTimer
	end_locaiton = %EndLocation
	spawn_location = %SpawnLocation

func _process(delta: float) -> void:
	SpinWheel()
	 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spin"):
		is_spinning = true
		timer.start(3)

		

func SpinWheel():
	if is_spinning:
		global_position += Vector2(0, 10) * timer.time_left 
		
		#if global_position.y >= end_locaiton.global_position.y: 
			#global_position.y = spawn_location.global_position.y
		

func _on_spin_timer_timeout() -> void:
	is_spinning = false
	#global_position.y += ReelFitting()
	var tween = create_tween()
	var adjusted_reel_fitting = ReelFitting()
	tween.tween_property(self, "position", global_position + Vector2(0, adjusted_reel_fitting), 4)
	

func ReelFitting() -> int:
	#var deadzone = int(slots_array[0].global_position.y / slots_array[0].texture.get_height()) % int(reels_array[0].global_position.y) 
	#position.y += 1
	#return deadzone
	var adjusted_pos_y = global_position.y
	while adjusted_pos_y < 0:
			adjusted_pos_y += slots_array[0].global_position.y
	var deadzone = int(adjusted_pos_y) % int(slots_array[0].global_position.y)
	
	var distance_to_add = 230 - deadzone
	
	return distance_to_add
