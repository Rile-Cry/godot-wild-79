extends Node2D

# Player pressed spin key
# Reels started to move between slots vertically
# After some move it stops

#TODO: Add multiple reels 
#TODO: Rename variable names
var slots_array = []
var i = 0
var n = 0
var j = 0
var timer 
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	slots_array = [%Slot_1, %Slot_2, %Slot_3]
	global_position = slots_array[0].global_position   
	timer = %Timer

	
func _process(delta: float) -> void:
	pass

#Player input
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spin"):
		n = rng.randi_range(5, 40)
		print(n)
		i += 1
		global_position = slots_array[i % 3].global_position
		timer.start(0.1)
		j = 0

# when player pressed spin first move reel
# after first move start a timer. 
# when timer ends move again
# after then start time again 
# this continues for x times 

func _on_timer_timeout() -> void:
	i += 1
	global_position = slots_array[i % 3].global_position
	if j < n:
		timer.start(0.1)
		j += 1
