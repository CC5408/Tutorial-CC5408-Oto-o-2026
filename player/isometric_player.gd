class_name IsometricPlayer
extends CharacterBody2D


@export var speed = 256
@export var acceleration = 1024


@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/movement/playback"]
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = %HealthBar


func _ready() -> void:
	health_bar.max_value = health_component.max_health
	health_component.health_changed.connect(_on_health_changed)
	_on_health_changed(health_component.health)


func _physics_process(_delta: float) -> void:
	var move_input: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var horizontal_input = Input.get_axis("move_left", "move_right")
	var vertical_input = Input.get_axis("move_up", "move_down")
	var isometric_move_input = Vector2(move_input.x - move_input.y, (move_input.x + move_input.y) / 2)
	
	if move_input.is_zero_approx():
		velocity = Vector2.ZERO
	elif (horizontal_input != 0 and vertical_input == 0) or (horizontal_input == 0 and vertical_input != 0):
		velocity = isometric_move_input * speed
	
	var attacking = animation_tree["parameters/attack_one_shot/active"]
	
	if attacking:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack") and not animation_tree["parameters/attack_one_shot/active"]:
		animation_tree["parameters/attack_one_shot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
	if Input.is_action_just_pressed("use"):
		Game.use_item(self)
	
	# animation
	
	if move_input.is_zero_approx():
		playback.travel("idle")
	else:
		playback.travel("walk")
		animation_tree["parameters/movement/idle/blend_position"] = move_input
		animation_tree["parameters/movement/walk/blend_position"] = move_input
		animation_tree["parameters/attack/blend_position"] = move_input
		
		sprite_2d.flip_h = horizontal_input < 0 or vertical_input > 0

func _on_health_changed(value: int) -> void:
	health_bar.value = value
