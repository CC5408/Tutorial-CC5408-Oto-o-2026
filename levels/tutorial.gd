extends Node2D

@onready var y_sort: Node2D = $YSort
@onready var isometric_player: IsometricPlayer = $YSort/IsometricPlayer
@onready var coin_dialogue_area: Area2D = $CoinDialogueArea
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	Game.coins_changed.connect(_on_coins_changed)
	
	coin_dialogue_area.body_entered.connect(_start_dialogue_by_area.bind(coin_dialogue_area, "res://dialogues/timelines/coins.dtl"))
	
	
	await play_dialogue("res://dialogues/timelines/tutorial_01.dtl")
	
	Debug.log("texto con delay")


func play_dialogue(dialogue: String) -> void:
	isometric_player.set_physics_process(false)
	Dialogic.start(dialogue)
	await Dialogic.timeline_ended
	isometric_player.set_physics_process(true)


func _start_dialogue_by_area(body: Node, area: Area2D, dialogue: String) -> void:
	var player: IsometricPlayer = body as IsometricPlayer
	if player:
		area.set_deferred("monitorable", false)
		area.set_deferred("monitoring", false)
		play_dialogue(dialogue)


func _on_coins_changed(value: int) -> void:
	if value > 0 and not hud.visible:
		hud.show()
