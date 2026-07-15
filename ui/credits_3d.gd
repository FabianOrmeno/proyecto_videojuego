extends Control

@export var scroll_speed = 50.0
@export var menu_scene_path = "res://ui/main_menu_3d.tscn"

@onready var credits_area: Control = $CreditsArea
@onready var credits_text: VBoxContainer= $CreditsArea/CreditsText
@onready var main_menu_button: Button = $MainMenuButton

var scrolling = false
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	
	credits_text.hide()
	
	await get_tree().process_frame
	
	credits_text.size.x = credits_area.size.x
	credits_text.queue_sort()
	
	await get_tree().process_frame
	
	credits_text.size.y = credits_text.get_combined_minimum_size().y
	credits_text.position = Vector2(0, credits_area.size.y)
	
	credits_text.show()
	scrolling = true

func _process(delta: float) -> void:
	if scrolling:
		credits_text.position.y -= delta * scroll_speed
		
		if credits_text.position.y + credits_text.size.y < 0:
			scrolling = false

func _on_main_menu_button_pressed() -> void:
	if menu_scene_path != "":
		get_tree().change_scene_to_file(menu_scene_path)
