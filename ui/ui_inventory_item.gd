@tool
class_name UIInventoryItem
extends HBoxContainer

@export var data: ItemData:
	set(value):
		data = value
		if not data:
			return
		if image:
			image.texture = data.image
		if name_label:
			name_label.text = data.display_name
@export var quantity: int:
	set(value):
		quantity = value
		if quantity_label:
			quantity_label.text = "x%d" % quantity


@onready var image: TextureRect = %Image
@onready var name_label: Label = %NameLabel
@onready var quantity_label: Label = %QuantityLabel
