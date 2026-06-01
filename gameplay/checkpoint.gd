extends Area2D

@export var marker: Marker2D

func _ready() -> void:
	if marker:
		body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node) -> void:
	var player: IsometricPlayer = body as IsometricPlayer
	if player:
		Game.last_checkpoint_position = marker.global_position
		Game.has_valid_checkpoint = true
