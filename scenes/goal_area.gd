extends Area3D

@export var victory_screen: VictoryScreen
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
var completed = false

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D) -> void:
	var player: Player3D = body as Player3D
	
	if player and not completed:
		completed = true
		
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		
		if victory_screen != null:
			victory_screen.start_victory()
