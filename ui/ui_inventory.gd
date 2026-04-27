extends Control

@export var inventory_item_scene: PackedScene

@onready var inventory_container: VBoxContainer = $InventoryContainer

func _ready() -> void:
	Game.inventory_changed.connect(update)


func update():
	for child in inventory_container.get_children():
		child.queue_free()
	if not inventory_item_scene:
		return
	for item_data in Game.inventory.keys():
		var inventory_item_inst: InventoryItem = inventory_item_scene.instantiate()
		inventory_container.add_child(inventory_item_inst)
		inventory_item_inst.data = item_data
		inventory_item_inst.quantity = Game.inventory[item_data]
