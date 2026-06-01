extends Control

@export var player_icon: Texture2D
@export var enemy_icon: Texture2D
@export var map_icon_scene: PackedScene
@export var level_tile_map: TileMapLayer

var zoom: float = 0.25
var can_zoom: bool = false

@onready var origin: Control = $PanelContainer/MarginContainer/Origin
@onready var panel_container: PanelContainer = $PanelContainer
@onready var tile_map_layer: TileMapLayer = $PanelContainer/MarginContainer/Origin/TileMapLayer

var map_icons: Array[MapIcon]

func _ready() -> void:
	
	if level_tile_map:
		tile_map_layer.tile_set = level_tile_map.tile_set
	
	panel_container.mouse_entered.connect(func(): can_zoom = true)
	panel_container.mouse_exited.connect(func(): can_zoom = false)
	
	await get_tree().create_timer(0.1).timeout
	
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	for player in players:
		var map_icon = create_map_icon(player, player_icon)
		map_icons.push_back(map_icon)
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		var map_icon =create_map_icon(enemy, enemy_icon)
		map_icons.push_back(map_icon)
		

func _input(event: InputEvent) -> void:
	if not can_zoom:
		return
	
	if event.is_action_pressed("zoom_up"):
		zoom *= 1.05
		
	if event.is_action_pressed("zoom_down"):
		zoom *= 0.95


func create_map_icon(target: Node2D, texture: Texture2D) -> MapIcon:
	if not map_icon_scene:
		return
	var map_icon_inst: MapIcon = map_icon_scene.instantiate()
	map_icon_inst.texture = texture
	map_icon_inst.target = target
	origin.add_child(map_icon_inst)
	return map_icon_inst

func _process(_delta: float) -> void:
	if not Game.player:
		return
	var player_position = Game.player.global_position
	for map_icon in map_icons:
		map_icon.position = (map_icon.target.global_position - player_position) * zoom
	
	if level_tile_map:
		var coords = level_tile_map.local_to_map(level_tile_map.to_local(player_position))
		
		var current_source_id = tile_map_layer.get_cell_source_id(coords)
		
		if current_source_id == -1:
			var source_id = level_tile_map.get_cell_source_id(coords)
			var atlas_coords = level_tile_map.get_cell_atlas_coords(coords)
			var alternative_tile = level_tile_map.get_cell_alternative_tile(coords)
			
			tile_map_layer.set_cell(coords, source_id, atlas_coords, alternative_tile)
			
	tile_map_layer.position = -player_position * zoom
		
