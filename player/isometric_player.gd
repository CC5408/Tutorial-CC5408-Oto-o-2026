class_name IsometricPlayer
extends CharacterBody2D


@export var speed = 256
@export var acceleration = 1024


@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/movement/playback"]
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = %HealthBar
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var marker_2d: Marker2D = $Skeleton2D/Marker2D


func _ready() -> void:
	Game.player = self
	health_bar.max_value = health_component.max_health
	health_component.health_changed.connect(_on_health_changed)
	_on_health_changed(health_component.health)
	health_component.died.connect(_on_died)
	if Game.has_valid_checkpoint:
		global_position = Game.last_checkpoint_position

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


func _on_died() -> void:
	set_physics_process(false)
	
	# disable collision
	collision_shape_2d.set_deferred("disabled", true)
	
	disable_collisions.call_deferred()
	
	var current_sprite_scale = sprite_2d.scale
	var tween = create_tween()
	tween.tween_property(sprite_2d, "scale", 2 * current_sprite_scale, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(sprite_2d, "modulate", Color.RED, 0.5)
	tween.tween_property(sprite_2d, "scale", 10 * current_sprite_scale, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(sprite_2d, "modulate:a", 0, 0.2)
	
	
	
	await tween.finished
	
	await get_tree().create_timer(1).timeout
	
	get_tree().reload_current_scene()

func disable_collisions() -> void:
	hurtbox_component.monitorable = false
	hurtbox_component.monitoring = false


func _process(delta: float) -> void:
	marker_2d.global_position = get_global_mouse_position()
