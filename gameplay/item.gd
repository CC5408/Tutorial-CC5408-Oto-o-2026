@tool
extends Area2D

@export var data: ItemData:
	set(value):
		data = value
		if data:
			update()

@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	update()
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var player = body as IsometricPlayer
	if player:
		queue_free()
		Game.add_item(data)
		

func update():
	if label:
		label.text = data.display_name
	if sprite_2d:
		sprite_2d.texture = data.image
