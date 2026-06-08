class_name UIItemSlot
extends Panel

var index: int = -1

@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label
@onready var key_label: Label = %KeyLabel

func _ready() -> void:
	if index < 0:
		index = get_index()
	Game.inventory_slot_changed.connect(_on_inventory_slot_changed)
	key_label.visible = index < 6
	key_label.text = str(index + 1)
	update()

func update() -> void:
	var slot: Game.Slot = Game.inventory[index]
	if slot.item_data:
		texture_rect.show()
		label.show()
		texture_rect.texture = slot.item_data.image
		label.text = str(slot.amount)
	else:
		texture_rect.hide()
		label.hide()

func _on_inventory_slot_changed(value: int) -> void:
	if index == value:
		update()


func _get_drag_data(_at_position: Vector2) -> Variant:
	var slot: Game.Slot = Game.inventory[index]
	if slot.is_empty():
		return null
	var preview = duplicate()
	preview.index = index
	set_drag_preview(preview)
	preview.key_label.hide()
	return index

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	Game.move_item(data, index)
