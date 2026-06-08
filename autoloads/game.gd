class_name UISlot
extends Node

signal coins_changed(value: int)
signal inventory_slot_changed(value: int)


var player: IsometricPlayer = null

var last_checkpoint_position: Vector2
var has_valid_checkpoint: bool = false

var coins: int = 0:
	set = set_coins
	
class Slot:
	var item_data: ItemData
	var amount: int:
		set(value):
			amount = max(value, 0)
			if amount == 0:
				item_data = null
	
	func is_empty() -> bool:
		return item_data == null
	
	func clear() -> void:
		item_data = null
		amount = 0


var inventory: Array[Slot]

func _ready() -> void:
	for i in 24:
		inventory.push_back(Slot.new())

func set_coins(value: int) -> void:
	coins = value
	coins_changed.emit(coins)

func add_item(item_data: ItemData, amount: int) -> int:
	# fill same item
	for i in inventory.size():
		var slot: Slot = inventory[i]
		if amount <= 0:
			break
		if slot.item_data == item_data:
			var diff = mini(item_data.stack_size - slot.amount, amount)
			slot.amount += diff
			amount -= diff
			inventory_slot_changed.emit(i)

	# fill empty slots
	for i in inventory.size():
		var slot: Slot = inventory[i]
		if amount <= 0:
			break
		if slot.is_empty():
			slot.item_data = item_data
			var diff = mini(item_data.stack_size, amount)
			slot.amount = diff
			amount -= diff
			inventory_slot_changed.emit(i)
	return amount

func move_item(from: int, to: int) -> void:
	var from_slot = inventory[from]
	var to_slot = inventory[to]
	# if same item
	if from_slot.item_data == to_slot.item_data:
		var diff = mini(to_slot.item_data.stack_size - to_slot.amount, from_slot.amount)
		to_slot.amount += diff
		from_slot.amount -= diff
	else:
		inventory[to] = from_slot
		inventory[from] = to_slot
	
	inventory_slot_changed.emit(from)
	inventory_slot_changed.emit(to)


func remove_item(index: int):
	inventory[index].clear()
	inventory_slot_changed.emit(index)

		
func use_item(index: int) -> void:
	if not inventory[index].is_empty() and player:
		inventory[index].item_data.action(player)
		inventory[index].amount -= 1
		inventory_slot_changed.emit(index)
