class_name Player
extends CharacterBody2D

enum State {
	MOVE,
	WALL_JUMP
}

var state = State.MOVE

@export var speed = 500
@export var jump_speed = 600
@export var acceleration = 300
@export var bullet_scene: PackedScene
@onready var jump_timer: Timer = $JumpTimer

var max_health = 20
var health = 20

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/movement/playback"]
@onready var pivot: Node2D = $Pivot
@onready var jump_stream_player: AudioStreamPlayer = $JumpStreamPlayer
@onready var hitbox_component: HitboxComponent = $Pivot/HitboxComponent
@onready var bullet_spawn_marker: Marker2D = $Pivot/BulletSpawnMarker
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var health_bar: ProgressBar = %HealthBar
@onready var health_component: HealthComponent = $HealthComponent



func _ready() -> void:
	hitbox_component.damage_dealt.connect(_on_damage_dealt)
	health_component.health_changed.connect(_on_health_changed)
	health_component.died.connect(_on_player_died)
	health_bar.max_value = health_component.max_health
	_on_health_changed(health_component.health)
	Game.coins = 100
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		LevelManager.next_level()


func _physics_process(delta: float) -> void:
	match state:
		State.MOVE:
			_move(delta)
		State.WALL_JUMP:
			_wall_jump(delta)
	

func _wall_jump(_delta: float) -> void:
	pass

func _move(delta: float) -> void:

	
	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(move_input * speed, acceleration * delta)
	
	move_and_slide()
	
	
	#if Input.is_action_just_pressed("use"):
		#Game.use_item(self)
	
	var firing = animation_tree["parameters/fire/active"]
	
	if not firing and Input.is_action_just_pressed("fire"):
		animation_tree["parameters/fire/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		pivot.scale.x = sign(get_global_mouse_position().x - global_position.x)
	
	if move_input.x:
		pivot.scale.x = sign(move_input.x)
	
	# animation
	if abs(velocity.x) > 10 or not move_input.is_zero_approx():
		playback.travel("run")
	else:
		playback.travel("idle")

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


func _on_health_changed(value: int) -> void:
	health_bar.value = value


func _on_player_died() -> void:
	queue_free()
	Debug.log("me moriii :C")
