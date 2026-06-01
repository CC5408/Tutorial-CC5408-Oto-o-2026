@tool
class_name MapIcon
extends Sprite2D

@export var size = 32:
	set(value):
		size = value
		if is_node_ready():
			update()

var target: Node2D

func _ready() -> void:
	update()

func update() -> void:
	scale = Vector2.ONE * size / texture.get_width()
	print(scale)
