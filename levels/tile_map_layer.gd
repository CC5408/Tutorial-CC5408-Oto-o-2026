extends TileMapLayer

@export var collision_tile_source_id: int
@export var collision_tile_atlas_coords: Vector2i

func _ready() -> void:
	var cells = get_used_cells()
	for coords in cells:
		var neighbors = get_surrounding_cells(coords)
		for neighbor_coords in neighbors:
			if get_cell_source_id(neighbor_coords) == -1:
				set_cell(neighbor_coords, collision_tile_source_id, collision_tile_atlas_coords)
