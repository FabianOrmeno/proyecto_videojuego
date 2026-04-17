extends Control

@onready var start: Button = %Start
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit


func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	credits.pressed.connect(_on_credits_pressed)
	quit.pressed.connect(_on_quit_pressed)
	
func _on_start_pressed():
	LevelManager.start()
	
func _on_credits_pressed():
	LevelManager.to_credits()
	
func _on_quit_pressed():
	get_tree().quit()
