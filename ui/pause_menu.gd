extends Control

@onready var resume: Button = %Resume
@onready var restart: Button = %Restart
@onready var main_menu: Button = %MainMenu
@onready var quit: Button = %Quit

func _ready() -> void:
	hide()
	resume.pressed.connect(_on_resume_pressed)
	restart.pressed.connect(_on_restart_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)
	quit.pressed.connect(_on_quit_pressed)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
	
func _on_resume_pressed():
	get_tree().paused = false
	hide()
	
func _on_restart_pressed():
	get_tree().paused = false
	LevelManager.restart_level()
	
func _on_main_menu_pressed():
	get_tree().paused = false
	LevelManager.to_main_menu()
	
func _on_quit_pressed():
	get_tree().quit()
