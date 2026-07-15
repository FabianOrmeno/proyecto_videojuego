extends Control

@export var background_light_on: Texture2D
@export var background_light_off: Texture2D
@export var menu_music: AudioStream

@export var min_time_between_flickers = 0.5
@export var max_time_between_flickers = 4.0
@export var flicker_duration = 0.1

@onready var texture_rect: TextureRect = $TextureRect
@onready var flicker_timer: Timer = $FlickerTimer



var random = RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()
	
	if background_light_on != null:
		texture_rect.texture = background_light_on
	
	if menu_music != null:
		AudioManager.play_music(menu_music)
		
	if not flicker_timer.timeout.is_connected(_on_flicker_timer_timeout):
		flicker_timer.timeout.connect(_on_flicker_timer_timeout)
	
	start_flicker_timer()


func start_flicker_timer() -> void:
	flicker_timer.wait_time = random.randf_range(min_time_between_flickers, max_time_between_flickers)
	flicker_timer.one_shot = true
	flicker_timer.start()


func _on_flicker_timer_timeout() -> void:
	if background_light_off != null:
		texture_rect.texture = background_light_off
	
	await get_tree().create_timer(flicker_duration).timeout
	
	if background_light_on != null:
		texture_rect.texture = background_light_on
	
	start_flicker_timer()

func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_3d.tscn")

func _on_button_exit_pressed() -> void:
	get_tree().quit()

func _on_button_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/tutorial_3d.tscn")
func _on_button_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/credits_3d.tscn")
