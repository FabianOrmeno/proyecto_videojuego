extends Node

@export var main_menu: PackedScene
@export var levels: Array[PackedScene]
@export var credits: PackedScene

var current_level = 0

func start() -> void:
	current_level = 0
	if not levels.is_empty() and levels[0]:
		get_tree().change_scene_to_packed(levels[0])
		
func restart_level() -> void:
	if current_level < levels.size() and levels[current_level]:
		get_tree().change_scene_to_packed(levels[current_level])

func next_level() -> void:
	current_level +=1
	if current_level < levels.size() and levels[current_level]:
		get_tree().change_scene_to_packed(levels[current_level])
	
func to_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu)
	
func to_credits() -> void:
	get_tree().change_scene_to_packed(credits)
	
