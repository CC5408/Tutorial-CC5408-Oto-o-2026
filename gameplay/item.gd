@tool
extends Area2D

@export var data: ItemData:
	set(value):
		data = value
		if data:
			update()
@export var quantity: int = 1:
	set(value):
		quantity = value
		update()


@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var quantity_label: Label = %QuantityLabel


func _ready() -> void:
	update()
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var player = body as IsometricPlayer
	if player:
		queue_free()
		var inventory_item = Game.InventoryItem.new(data, -1, quantity)
		Game.add_item(inventory_item)


func update():
	if label:
		label.text = data.display_name
	if sprite_2d:
		sprite_2d.texture = data.image
	if quantity_label:
		quantity_label.text = str(quantity)
