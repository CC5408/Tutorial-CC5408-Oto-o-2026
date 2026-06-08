class_name UIDropZone
extends Control

@export var item_scene: PackedScene

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if not item_scene:
		return
	var slot: Game.Slot = Game.inventory[data]
	var item_data: ItemData = slot.item_data
	var amount: int = slot.amount
	Game.remove_item(data)
	var item_inst: Item = item_scene.instantiate()
	item_inst.data = item_data
	item_inst.amount = amount
	LevelManager.current_level_scene.add_child_to_level(item_inst)
