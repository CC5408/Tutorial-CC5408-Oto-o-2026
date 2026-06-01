class_name Enemy
extends CharacterBody2D

@export var speed = 100
@export var acceleration = 300

var target_player: IsometricPlayer

@onready var pivot: Node2D = $Pivot
@onready var detection_area_2d: Area2D = $DetectionArea2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var follow_timer: Timer = $FollowTimer

func _ready() -> void:
	detection_area_2d.body_entered.connect(_on_body_entered)
	detection_area_2d.body_exited.connect(_on_body_exited)
	follow_timer.timeout.connect(_update_target_position)
	navigation_agent_2d.velocity_computed.connect(_on_velocity_computed)
	
	#await get_tree().create_timer(1).timeout
	#target_player = Game.player
	#_update_target_position()
	#follow_timer.start()
	
func _physics_process(delta: float) -> void:
	
	if target_player:
		var horizontal_direction = sign(target_player.global_position.x - global_position.x)
		#Debug.log(horizontal_direction, 2 * delta)
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

func _on_body_entered(body: Node) -> void:
	var player = body as IsometricPlayer
	if player:
		target_player = player
		_update_target_position()
		follow_timer.start()

func _on_body_exited(body: Node) -> void:
	var player = body as IsometricPlayer
	if player and player == target_player:
		follow_timer.stop()
		target_player = null

func _update_target_position() -> void:
	if target_player:
		navigation_agent_2d.target_position = target_player.global_position


func _on_velocity_computed(safe_veloctiy: Vector2) -> void:
	velocity = safe_veloctiy
	move_and_slide()
