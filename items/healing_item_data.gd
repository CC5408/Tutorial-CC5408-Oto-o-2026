class_name HealingItemData
extends ItemData

@export var amount: int

func action(player: IsometricPlayer) -> void:
	player.health_component.health += amount
