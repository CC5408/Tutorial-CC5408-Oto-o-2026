@tool
extends Control

@export var slot_scene: PackedScene
@export var slots: int = 24:
	set(value):
		slots = value
		if is_node_ready():
			create_slots()

@export var item_slots: int = 6:
	set(value):
		item_slots = value
		if is_node_ready():
			create_item_slots()

@onready var slot_container: GridContainer = %SlotContainer
@onready var item_slot_container: GridContainer = %ItemSlotContainer
@onready var slot_panel: PanelContainer = %SlotPanel
@onready var item_slot_panel: PanelContainer = %ItemSlotPanel

func _ready() -> void:
	create_slots()
	create_item_slots()
	item_slot_panel.show()
	slot_panel.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		item_slot_panel.visible = not item_slot_panel.visible
		slot_panel.visible = not slot_panel.visible
	var items = ["1", "2", "3", "4", "5", "6"]
	for i in items.size():
		if event.is_action_pressed(items[i]):
			Game.use_item(i)


func create_slots() -> void:
	for child in slot_container.get_children():
		child.queue_free()
	for i in slots:
		var slot_inst = slot_scene.instantiate()
		slot_container.add_child(slot_inst)

func create_item_slots() -> void:
	for child in item_slot_container.get_children():
		child.queue_free()
	for i in item_slots:
		var slot_inst = slot_scene.instantiate()
		item_slot_container.add_child(slot_inst)
