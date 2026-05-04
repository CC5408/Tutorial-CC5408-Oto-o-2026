class_name ItemData
extends Resource

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}

@export var display_name: String
@export_multiline() var description: String
@export var image: Texture2D
@export var price: int
@export var rarity: Rarity
@export var stack_size: int = 64

func action(player: IsometricPlayer) -> void:
	pass
