class_name VictoryScreen
extends Control

@export var all_white_texture: Texture2D
@export var win_texture: Texture2D

@export var white_time = 2.0
@export var fade_time = 1.0
@export var menu_scene_path = ""

@onready var victory_panel: Control = $VictoryPanel
@onready var background: TextureRect = $VictoryPanel/Background
@onready var main_menu_button: Button = $VictoryPanel/VBoxContainer/MainMenuButton
@onready var white_screen: TextureRect = $VictoryPanel/WhiteScreen
@export var victory_music: AudioStream
@export var victory_music_start = 20.0

var victory_started = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	hide()
	victory_panel.hide()
	white_screen.hide()
	
	if all_white_texture != null:
		white_screen.texture = all_white_texture
	
	if win_texture != null:
		background.texture = win_texture
	
	white_screen.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	white_screen.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	
	victory_panel.z_index = 0
	white_screen.z_index = 10
	
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func start_victory() -> void:
	if victory_started:
		return
	
	victory_started = true
	
	show()
	victory_panel.show()
	white_screen.show()
	
	white_screen.modulate.a = 1.0
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if victory_music != null:
		AudioManager.play_music(victory_music, victory_music_start)
		get_tree().paused = true
	
	await get_tree().create_timer(white_time, true).timeout
	
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(white_screen, "modulate:a", 0.0, fade_time)
	
	await tween.finished
	
	white_screen.hide()
	main_menu_button.grab_focus()

func is_victory_active() -> bool:
	return victory_started

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	
	if menu_scene_path != "":
		get_tree().change_scene_to_file(menu_scene_path)
