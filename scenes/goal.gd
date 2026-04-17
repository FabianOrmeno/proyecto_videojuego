extends Area2D

@export var victory_sound: AudioStream

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var compleated = false

func _ready() -> void:
	body_entered.connect(on_body_entered)
	
func on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player and not compleated:
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		AudioManager.play_sfx(victory_sound)
		await get_tree().create_timer(2).timeout
		LevelManager.next_level()
