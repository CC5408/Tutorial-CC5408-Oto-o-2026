extends CharacterBody2D

@export var speed = 100
@export var acceleration = 300

@onready var timer: Timer = $Timer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var dialogue_area: Area2D = $DialogueArea

func _ready() -> void:
	timer.timeout.connect(_on_timeout)
	navigation_agent_2d.velocity_computed.connect(_on_velocity_computed)
	dialogue_area.body_entered.connect(_try_dialogue)


func _physics_process(_delta: float) -> void:
	if navigation_agent_2d.is_target_reached():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var next_position = navigation_agent_2d.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.velocity = direction * speed
	else:
		_on_velocity_computed(direction * speed)



func _on_velocity_computed(safe_veloctiy: Vector2) -> void:
	velocity = safe_veloctiy
	move_and_slide()


func _on_timeout() -> void:
	var new_target = global_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
	navigation_agent_2d.target_position = new_target


func _try_dialogue(body: Node)-> void:
	var player: IsometricPlayer = body as IsometricPlayer
	if player:
		Dialogic.start("res://dialogues/timelines/test_coin.dtl")
