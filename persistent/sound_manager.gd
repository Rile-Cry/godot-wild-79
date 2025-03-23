extends Node

var playing_ids : Dictionary[int, Array] = {
	
}

func _ready() -> void:
	Wwise.load_bank("slotlike230325")

func play(stream_id: int) -> void:
	var playing_id = Wwise.post_event_id_callback(stream_id, AkUtils.AkCallbackType.AK_END_OF_EVENT, self, _stop_callback)
	if playing_ids.has(stream_id):
		playing_ids[stream_id].append(playing_id)
	else:
		playing_ids[stream_id] = [playing_id]

func stop(stream_id: int) -> void:
	if playing_ids.has(stream_id):
		if playing_ids.get(stream_id).size() > 1:
			var id = playing_ids.get(stream_id).pop_front()
			Wwise.stop_event(id, 1, AkUtils.AkCurveInterpolation.AK_CURVE_LINEAR)
		else:
			Wwise.stop_event(playing_ids.get(stream_id)[0], 1, AkUtils.AkCurveInterpolation.AK_CURVE_LINEAR)
			playing_ids.erase(stream_id)

func _set_phase(phase_id:int) -> void:
	Wwise.set_state_id(AK.STATES.PHASE.GROUP,phase_id)
	pass

func _set_intensity(intensity_id) -> void:
	Wwise.set_state_id(AK.STATES.INTENSITY.GROUP,intensity_id)
	pass

func soundtrack_crossfade() -> void:
	stop(AK.EVENTS.OST)
	play(AK.EVENTS.OST)

func stop_all() -> void:
	for stream_id in playing_ids.keys():
		while playing_ids.has(stream_id):
			stop(stream_id)

func _stop_callback(data: Dictionary) -> void:
	stop(data.get("eventID"))
