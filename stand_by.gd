extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
var direction: Vector2
var speed = 300

func _ready() -> void:
	direction = Vector2.from_angle(randf_range(0, 2 * PI))
	


func _process(delta: float) -> void:
	var half_size: Vector2 = sprite_2d.get_rect().size * sprite_2d.scale / 2
	if (sprite_2d.position.x - half_size.x) <= 0 or (sprite_2d.position.x + half_size.x) > get_viewport_rect().size.x:
		direction = direction.bounce(Vector2.RIGHT)
	if (sprite_2d.position.y - half_size.y) <= 0 or (sprite_2d.position.y + half_size.y) > get_viewport_rect().size.y:
		direction = direction.bounce(Vector2.UP)
	if sprite_2d.position.x - half_size.x < 0:
		sprite_2d.position.x = half_size.x
	if sprite_2d.position.x + half_size.x > get_viewport_rect().size.x:
		sprite_2d.position.x = get_viewport_rect().size.x - half_size.x
	if sprite_2d.position.y - half_size.y < 0:
		sprite_2d.position.y = half_size.y
	if sprite_2d.position.y + half_size.y > get_viewport_rect().size.y:
		sprite_2d.position.y = get_viewport_rect().size.y - half_size.y
	
	sprite_2d.position += direction * speed * delta
