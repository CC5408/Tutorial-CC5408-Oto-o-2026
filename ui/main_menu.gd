extends Control

@onready var start: Button = %Start
@onready var quit: Button = %Quit

func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	quit.pressed.connect(_on_quit_pressed)


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()
