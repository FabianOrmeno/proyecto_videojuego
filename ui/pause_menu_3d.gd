extends Control

@export var pause_music: AudioStream

@onready var resume_button: Button = %"Button (Resume)"
@onready var restart_button: Button = %"Button (Restart)"
@onready var main_menu_button: Button = %"Button (Main Menu)"
@onready var game_over_screen: GameOverScreen = $"../GameOverScreen"
@onready var victory_screen: VictoryScreen = $"../VictoryScreen"

var music_before_pause: AudioStream
var music_position_before_pause = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()


func _input(event: InputEvent) -> void:
	if game_over_screen != null and game_over_screen.is_game_over_active():
		return
	if victory_screen != null and victory_screen.is_victory_active():
		return
	if event.is_action_pressed("pause"):
		toggle_pause()


func toggle_pause() -> void:
	if game_over_screen != null and game_over_screen.is_game_over_active():
		return
	if victory_screen != null and victory_screen.is_victory_active():
		return
		
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused

	if get_tree().paused:
		music_before_pause = AudioManager.current_music
		music_position_before_pause = AudioManager.get_music_position()
		
		if pause_music != null:
			AudioManager.play_music(pause_music)
		
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		if music_before_pause != null:
			AudioManager.play_music(music_before_pause, music_position_before_pause)
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_button_resume_pressed() -> void:
	toggle_pause()


func _on_button_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_button_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu_3d.tscn")

func _on_button_tutorial_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/tutorial_3d.tscn")
