class_name Level
extends Node2D

@onready var y_sort: Node2D = $YSort

func _ready() -> void:
	LevelManager.current_level_scene = self

func add_child_to_level(node: Node2D) -> void:
	y_sort.add_child(node)
	node.global_position = get_global_mouse_position()
