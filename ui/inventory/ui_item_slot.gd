extends Panel

var inventory_item: Game.InventoryItem
@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label

func _ready() -> void:
	Game.slot_updated.connect(_on_slot_updated)

func update() -> void:
	if inventory_item:
		texture_rect.show()
		label.show()
		texture_rect.texture = inventory_item.get_item_data().image
		label.text = str(inventory_item.get_quantity())
	else:
		texture_rect.hide()
		label.hide()

func _on_slot_updated(index: int) -> void:
	if get_index() == index:
		inventory_item = Game.inventory[index]
		update()


func _get_drag_data(_at_position: Vector2) -> Variant:
	if not inventory_item:
		return null
	var preview = duplicate()
	set_drag_preview(preview)
	var quantity: int = inventory_item.get_quantity()
	if Input.is_action_pressed("half"):
		quantity /= 2
	preview.label.text = str(quantity)
	return {"inventory_item": inventory_item, "quantity": quantity}

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	Game.move_item(get_index(), data.inventory_item, data.quantity)
