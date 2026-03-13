extends CharacterBody2D

@export var speed = 500
@export var jump_speed = 600
@export var acceleration = 300
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var pivot: Node2D = $Pivot


func _ready() -> void:
	animation_player.play("run")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
	
	var move_input = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, move_input * speed, acceleration * delta)
	
	move_and_slide()
	
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
			
