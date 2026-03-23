extends CharacterBody2D

@export var speed = 500
@export var jump_speed = 600
@export var acceleration = 300
@export var bullet_scene: PackedScene
@onready var jump_timer: Timer = $JumpTimer

var max_health = 20
var health = 20
var _was_on_floor: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/movement/playback"]
@onready var pivot: Node2D = $Pivot
@onready var jump_stream_player: AudioStreamPlayer = $JumpStreamPlayer
@onready var hitbox_component: HitboxComponent = $Pivot/HitboxComponent
@onready var bullet_spawn_marker: Marker2D = $Pivot/BulletSpawnMarker
@onready var coyote_timer: Timer = $CoyoteTimer



func _ready() -> void:
	hitbox_component.damage_dealt.connect(_on_damage_dealt)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		LevelManager.next_level()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	if not is_on_floor() and _was_on_floor:
		coyote_timer.start()
	
	if (is_on_floor() or not coyote_timer.is_stopped()) and Input.is_action_just_pressed("jump") and jump_timer.is_stopped():
		jump_timer.start()
		jump_stream_player.play()
	if Input.is_action_just_released("jump"):
		jump_timer.stop()
	if not jump_timer.is_stopped():
		#velocity.y = -jump_speed * (jump_timer.time_left / jump_timer.wait_time)
		velocity.y = -jump_speed
	
	var move_input = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, move_input * speed, acceleration * delta)
	
	_was_on_floor = is_on_floor()
	
	move_and_slide()
	
	var firing = animation_tree["parameters/fire/active"]
	
	if not firing and Input.is_action_just_pressed("fire"):
		animation_tree["parameters/fire/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
	if move_input:
		pivot.scale.x = sign(move_input)
	
	# animation
	if is_on_floor():
		if abs(velocity.x) > 10 or move_input:
			playback.travel("run")
		else:
			playback.travel("idle")
	else:
		if velocity.y < 0:
			playback.travel("jump")
		else:
			playback.travel("fall")
	



func take_damage(value: int) -> void:
	Debug.log("%s received %d damage" % [name, value])
	health -= value
	if health <= 0:
		queue_free()
		Debug.log("me moriii :C")

func _on_damage_dealt() -> void:
	Debug.log("I made damage")


func fire() -> void:
	if not bullet_scene:
		Debug.log("me olvido poner la bala · 0 ·)>")
	var bullet_inst = bullet_scene.instantiate()
	get_parent().add_child(bullet_inst)
	bullet_inst.global_position = bullet_spawn_marker.global_position
	var mouse_direction = bullet_spawn_marker.global_position.direction_to(get_global_mouse_position())
	bullet_inst.global_rotation = mouse_direction.angle()
