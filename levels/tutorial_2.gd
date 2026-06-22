extends Node2D

@onready var tree: StaticBody2D = $Tree
@onready var button: Node2D = $Button

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	if is_instance_valid(tree):
		tree.queue_free()
	
