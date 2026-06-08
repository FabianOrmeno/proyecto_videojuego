extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var current_music: AudioStream
var current_music_path = ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.bus = "Music"


func play_music(music: AudioStream, from_position = 0.0, force_restart = false) -> void:
	if music == null:
		return
	
	if is_same_music(music) and music_player.playing and not force_restart:
		return
	
	current_music = music
	current_music_path = music.resource_path
	
	music_player.stream = music
	music_player.bus = "Music"
	music_player.play(from_position)


func is_same_music(music: AudioStream) -> bool:
	if current_music == music:
		return true
	
	if current_music_path != "" and music.resource_path != "":
		if current_music_path == music.resource_path:
			return true
	
	return false


func get_music_position() -> float:
	return music_player.get_playback_position()


func stop_music() -> void:
	music_player.stop()
	current_music = null
	current_music_path = ""


func play_sfx(sfx: AudioStream) -> void:
	if sfx == null:
		return
	
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	player.bus = "SoundEffects"
	player.stream = sfx
	player.play()
	
	await player.finished
	
	player.queue_free()
