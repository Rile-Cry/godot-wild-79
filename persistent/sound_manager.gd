extends Node

var music_dir : StringName = "res://assets/music/"
var music_pool : Dictionary[StringName, AudioStream]
var music_stream : AudioStreamPlayer
var sfx_dir : StringName = "res://assets/sfx/"
var sfx_pool : Dictionary[StringName, AudioStream]
var sfx_streams : Array[AudioStreamPlayer]
var sfx_channels : int = 3

func _ready() -> void:
	music_stream = AudioStreamPlayer.new()
	music_stream.bus = "Music"
	add_child(music_stream)
	for channel in range(sfx_channels):
		sfx_streams.append(AudioStreamPlayer.new())
		sfx_streams[channel].bus = "SFX"
		sfx_streams[channel].volume_db = -channel * 10
		add_child(sfx_streams[channel])
	
	_load_music()
	_load_sfx()

func play_music(stream_name: StringName) -> void:
	music_stream.stream = music_pool[stream_name]
	music_stream.play()

func play_sfx(stream_name: StringName, channel_idx: int = -1) -> void:
	if channel_idx == -1:
		for channel in sfx_streams:
			if channel.playing:
				continue
			else:
				channel.stream = sfx_pool[stream_name]
				channel.play()
	else:
		sfx_streams[channel_idx].stream = sfx_pool[stream_name]
		sfx_streams[channel_idx].play()

func stop_sfx(channel_idx: int = 0) -> void:
	sfx_streams[channel_idx].stop()
	sfx_streams[channel_idx].stream = null

func _load_music() -> void:
	var music_list := ResourceLoader.list_directory(music_dir)
	for song in music_list:
		var song_name = song.split(".")[0]
		music_pool.set(song_name, ResourceLoader.load(music_dir + song, "AudioStream"))

func _load_sfx() -> void:
	var sfx_list := ResourceLoader.list_directory(sfx_dir)
	for sound in sfx_list:
		var sound_name = sound.split(".")[0]
		sfx_pool.set(sound_name, ResourceLoader.load(sfx_dir + sound, "AudioStream"))
