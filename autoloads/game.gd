extends Node

signal coins_changed(value: int)
signal inventory_changed()


var coins: int = 0:
	set = set_coins

var inventory: Dictionary[ItemData, int]

func set_coins(value: int) -> void:
	coins = value
	coins_changed.emit(coins)

func add_item(item_data: ItemData):
	if not inventory.has(item_data):
		inventory[item_data] = 0
	inventory[item_data] += 1
	inventory_changed.emit()

func remove_item(item_data: ItemData):
	if not inventory.has(item_data):
		return
	inventory[item_data] -= 1
	if inventory[item_data] == 0:
		inventory.erase(item_data)
	inventory_changed.emit()

		
func use_item(player: IsometricPlayer) -> void:
	for item_data: ItemData in inventory.keys():
		var healing_item_data = item_data as HealingItemData
		if healing_item_data:
			healing_item_data.action(player)
			remove_item(item_data)
