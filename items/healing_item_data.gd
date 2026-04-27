class_name HealingItemData
extends ItemData

@export var amount: int

func action(player: Player) -> void:
	player.health_component.health += amount
