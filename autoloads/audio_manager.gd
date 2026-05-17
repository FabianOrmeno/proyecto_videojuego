extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var current_music: AudioStream


func play_music(music: AudioStream, from_position = 0.0) -> void:
	if music == null:
		return
	
	if current_music == music and music_player.playing:
		return
	
	current_music = music
	music_player.stream = music
	music_player.play(from_position)


func get_music_position() -> float:
	return music_player.get_playback_position()


func stop_music() -> void:
	music_player.stop()
	current_music = null


func play_sfx(sfx: AudioStream):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	player.bus = "SoundEffects"
	player.stream = sfx
	player.play()
	await player.finished
	player.queue_free()
