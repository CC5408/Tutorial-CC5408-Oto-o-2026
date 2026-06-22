extends Node2D

signal pressed

@onready var area_2d: Area2D = $Area2D
@onready var label: Label = $Label

var inside: bool = false:
	set(value):
		inside = value
		label.visible = inside

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	label.hide()


func _input(event: InputEvent) -> void:
	if not inside:
		return
	if event.is_action_pressed("interact"):
		pressed.emit()

func _on_body_entered(body: Node2D) ->  void:
	var player: IsometricPlayer = body as IsometricPlayer
	if player:
		inside = true


func _on_body_exited(body: Node2D) ->  void:
	var player: IsometricPlayer = body as IsometricPlayer
	if player:
		inside = false
