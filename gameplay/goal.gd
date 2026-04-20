extends Area2D

@export var sfx: AudioStream
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		gpu_particles_2d.emitting = true
		timer.start()
		get_tree().paused = true
		await timer.timeout
		get_tree().paused = false
		LevelManager.next_level()
		AudioManager.play_sfx(sfx)
		AudioManager.play_sfx(sfx)
		
