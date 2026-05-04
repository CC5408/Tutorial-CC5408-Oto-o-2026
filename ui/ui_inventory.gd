@tool
extends Control

@export var inventory_item_scene: PackedScene
@export var item_slot_scene: PackedScene
@export var slots: int = 24:
	set(value):
		slots = value
		create_slots()

@onready var slot_container: GridContainer = %SlotContainer

func _ready() -> void:
	create_slots()


func create_slots() -> void:
	for child in slot_container.get_children():
		child.queue_free()
	for i in slots:
		var item_slot_inst = item_slot_scene.instantiate()
		slot_container.add_child(item_slot_inst)

	
