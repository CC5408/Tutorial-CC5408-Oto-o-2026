extends CharacterBody2D

func take_damage(value: int) -> void:
	Debug.log("%s received %d damage" % [name, value])
