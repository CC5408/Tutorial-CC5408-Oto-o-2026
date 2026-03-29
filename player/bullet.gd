extends HitboxComponent

@export var speed: int = 600
@onready var timer: Timer = $Timer


func _ready() -> void:
	#timer.timeout.connect(func(): queue_free())
	await get_tree().create_timer(1).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	var direction = global_transform.x
	global_position += direction * speed * delta
