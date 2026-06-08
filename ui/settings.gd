extends Control

@export var test_sfx: AudioStream

@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider

func _ready() -> void:
	update()
	music_slider.value_changed.connect(_on_music_changed)
	music_slider.drag_ended.connect(_on_music_drag_ended)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	sfx_slider.drag_ended.connect(_on_sfx_drag_ended)

func _on_music_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))


func _on_sfx_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_linear(bus, value)

func update() -> void:
	var music_bus = AudioServer.get_bus_index("Music")
	var sfx_bus = AudioServer.get_bus_index("SFX")
	
	music_slider.value = AudioServer.get_bus_volume_linear(music_bus)
	sfx_slider.value = AudioServer.get_bus_volume_linear(sfx_bus)

func _on_music_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var config = ConfigFile.new()
		
		var err = config.load("user://settings.cfg")

		if err != OK:
			return

		config.set_value("Audio", "music", music_slider.value)
		config.save("user://settings.cfg")

func _on_sfx_drag_ended(value_changed: bool) -> void:
	AudioManager.play_sfx(test_sfx)
	
	if value_changed:
		var config = ConfigFile.new()
		
		var err = config.load("user://settings.cfg")

		if err != OK:
			return
		
		config.set_value("Audio", "sfx", sfx_slider.value)
		config.save("user://settings.cfg")
