extends Control

@onready var rich_text_label: RichTextLabel = $RichTextLabel/RichTextLabel
@onready var main_menu: Button = %MainMenu

var scrolling: bool = false
var scroll_speed = 100

func _ready() -> void:
	main_menu.pressed.connect(_on_main_menu_pressed)
	await get_tree().create_timer(2).timeout
	scrolling = true
	
func _on_main_menu_pressed():
	LevelManager.to_main_menu()
	
func _process(delta: float) -> void:
	if scrolling:
		var scroll_bar: VScrollBar = rich_text_label.get_v_scroll_bar()
		scroll_bar.value += delta*scroll_speed
