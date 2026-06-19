extends Node2D

func _ready() -> void:
	Dialogic.start("res://dialogues/timelines/intro.dtl")
	await Dialogic.timeline_ended
	LevelManager.next_level()
