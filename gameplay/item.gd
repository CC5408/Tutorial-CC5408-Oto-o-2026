@tool
class_name Item
extends Area2D

@export var data: ItemData:
	set(value):
		data = value
		if data:
			update()
@export var amount: int = 1:
	set(value):
		amount = max(value, 1)
		update()


@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var amount_label: Label = %QuantityLabel


func _ready() -> void:
	update()
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var player = body as IsometricPlayer
	if player:
		var remaining = Game.add_item(data, amount)
		if not remaining:
			queue_free()
		else:
			amount = remaining


func update():
	if label:
		label.text = data.display_name
	if sprite_2d:
		sprite_2d.texture = data.image
	if amount_label:
		amount_label.text = str(amount)
