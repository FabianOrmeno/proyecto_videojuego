extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer

func _ready() -> void:
	play_music()

func play_music():
	music_player.play()

func play_sfx(sfx: AudioStream):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "SoundEffects"
	player.stream = sfx
	player.play()
	await player.finished
	player.queue_free()
