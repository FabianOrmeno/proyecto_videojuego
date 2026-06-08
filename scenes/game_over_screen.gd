class_name GameOverScreen
extends Control

@export var jump_normal_texture: Texture2D
@export var jump_byn_texture: Texture2D
@export var game_over_texture: Texture2D
@export var jumpscare_sfx: AudioStream
@export var game_over_music: AudioStream

@export var screamer_time = 2.0
@export var blink_time = 0.05
@export var menu_scene_path = ""

@onready var screamer = $Screamer
@onready var game_over_panel = $GameOverPanel
@onready var background = $GameOverPanel/Background
@onready var back_to_menu_button = $GameOverPanel/VBoxContainer/BackToMenuButton
@onready var exit_button = $GameOverPanel/VBoxContainer/ExitButton
@onready var blink_timer = $GameOverPanel/BlinkTimer
@onready var screamer_timer = $GameOverPanel/ScreamerTimer

var game_over_requested = false
var game_over_started = false
var showing_normal = true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	blink_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	screamer_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	
	hide()
	screamer.hide()
	game_over_panel.hide()
	
	if game_over_texture != null:
		background.texture = game_over_texture
	
	blink_timer.wait_time = blink_time
	blink_timer.one_shot = false
	
	screamer_timer.wait_time = screamer_time
	screamer_timer.one_shot = true
	
	blink_timer.timeout.connect(_on_blink_timer_timeout)
	screamer_timer.timeout.connect(_on_screamer_timer_timeout)
	back_to_menu_button.pressed.connect(_on_back_to_menu_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)


func request_game_over() -> void:
	game_over_requested = true


func is_game_over_active() -> bool:
	return game_over_requested or game_over_started


func start_game_over() -> void:
	if game_over_started:
		return
	
	game_over_requested = true
	game_over_started = true
	
	show()
	screamer.show()
	game_over_panel.hide()
	
	showing_normal = true
	screamer.texture = jump_normal_texture
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	AudioManager.stop_music()
	
	if jumpscare_sfx != null:
		AudioManager.play_sfx(jumpscare_sfx)
	
	get_tree().paused = true
	
	blink_timer.start()
	screamer_timer.start()


func _on_blink_timer_timeout() -> void:
	if showing_normal:
		screamer.texture = jump_byn_texture
	else:
		screamer.texture = jump_normal_texture
	
	showing_normal = !showing_normal


func _on_screamer_timer_timeout() -> void:
	blink_timer.stop()
	screamer.hide()
	game_over_panel.show()
	
	if game_over_music != null:
		AudioManager.play_music(game_over_music)


func _on_back_to_menu_button_pressed() -> void:
	get_tree().paused = false
	
	if menu_scene_path != "":
		get_tree().change_scene_to_file(menu_scene_path)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
