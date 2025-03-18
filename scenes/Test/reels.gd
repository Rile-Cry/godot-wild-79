extends Node2D


var num_1 = 20
var num_2 = 87

var slots_array = []
var reels_array = []
var timer 
var is_spinning 
var end_locaiton
var spawn_location

# 910x 1200px end location
#

func _ready() -> void:
	reels_array = [%Apple_1, %Banana_1, %Cherry_1, %Apple_2, %Banana_2]
	slots_array = [%Slot_1, %Slot_2, %Slot_3, %Slot_4, %Slot_5]
	timer = %SpinTimer
	end_locaiton = %EndLocation
	spawn_location = %SpawnLocation
	
	for i in reels_array.size():
		reels_array[i].global_position = slots_array[i].global_position

func _process(delta: float) -> void:
		SpinWheel()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spin"):
		is_spinning = true
		timer.start(5)
		

func SpinWheel():
	if is_spinning:
		global_position += Vector2(0, 10) * timer.time_left
		
		if global_position.y >= end_locaiton.global_position.y: 
			global_position.y = spawn_location.global_position.y


func _on_spin_timer_timeout() -> void:
	is_spinning = false
	print(ReelFitting())

func ReelFitting() -> int:
	var deadzone = int(slots_array[0].global_position.y / slots_array[0].texture.get_height()) % int(reels_array[0].global_position.y) 
	position.y += 1
	return deadzone
	
