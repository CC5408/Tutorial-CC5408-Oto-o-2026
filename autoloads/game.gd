class_name UIItemSlot
extends Node

signal coins_changed(value: int)
signal inventory_changed()
signal slot_updated(index: int)


var coins: int = 0:
	set = set_coins
	
class InventoryItem:
	var _item_data: ItemData
	var _slot_index: int
	var _quantity: int
	
	func _init(item_data: ItemData, slot_index: int, quantity: int) -> void:
		_item_data = item_data
		_slot_index = slot_index
		_quantity = quantity
	
	func get_slot_index() -> int:
		return _slot_index
	
	func get_quantity() -> int:
		return _quantity
		
	func get_item_data() -> ItemData:
		return _item_data

var inventory: Array[InventoryItem]

func _ready() -> void:
	for i in 24:
		inventory.resize(24)

func set_coins(value: int) -> void:
	coins = value
	coins_changed.emit(coins)

func add_item(item: InventoryItem):
	# find available slot
	var available_slot_index = -1
	
	for i: int in inventory.size():
		var inventory_item: InventoryItem = inventory[i]
		if not inventory_item:
			if available_slot_index == -1:
				available_slot_index = i
		elif inventory_item._item_data == item._item_data:
			var total_quantity: int = inventory_item._quantity + item._quantity
			if  total_quantity <= item._item_data.stack_size:
				inventory_item._quantity += item._quantity
				slot_updated.emit(i)
				return
			else:
				var remainig = total_quantity - item._item_data.stack_size 
				inventory_item._quantity = item._item_data.stack_size
				item._quantity = remainig
				slot_updated.emit(i)
				
	
	if available_slot_index == -1:
		return
	
	item._slot_index = available_slot_index
	inventory[available_slot_index] = item

	slot_updated.emit(available_slot_index)

func move_item(index: int, item: InventoryItem) -> void:
	var previous_item_slot = item._slot_index
	var current_item = inventory[index]
	if current_item:
		inventory[previous_item_slot] = current_item
		current_item._slot_index = previous_item_slot
		slot_updated.emit(previous_item_slot)
		
	inventory[index] = item
	item._slot_index = index
	slot_updated.emit(index)
	
	if not current_item:
		inventory[previous_item_slot] = null
		slot_updated.emit(previous_item_slot)

		 


func remove_item(item_data: ItemData):
	if not inventory.has(item_data):
		return
	#inventory[item_data] -= 1
	#if inventory[item_data] == 0:
		#inventory.erase(item_data)
	#inventory_changed.emit()

		
func use_item(player: IsometricPlayer) -> void:
	pass
	#for item_data: ItemData in inventory.keys():
		#var healing_item_data = item_data as HealingItemData
		#if healing_item_data:
			#healing_item_data.action(player)
			#remove_item(item_data)
