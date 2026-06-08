extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer

func _ready() -> void:
	load_settings()

	play_music()

func play_music() -> void:
	music_player.play()

func play_sfx(sfx: AudioStream) -> void:
	var player = AudioStreamPlayer.new()
	player.stream = sfx
	player.bus = "SFX"
	add_child(player)
	player.play()
	await player.finished
	player.queue_free()


func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		return
	var music = config.get_value("Audio", "music")
	var sfx = config.get_value("Audio", "sfx")
	
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), music)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), sfx)
