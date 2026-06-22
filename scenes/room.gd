extends Node2D

@export var width: int = 6
@export var height: int = 4
@export var path_size: int = 12
@export var branch_amount: int = 4
@export var branch_length_min: int = 2
@export var branch_length_max: int = 4

var DIRECTIONS = [
	Vector2i(1,0),
	Vector2i(-1,0),
	Vector2i(0,1),
	Vector2i(0,-1),
]


var room: Array

var branches: Array[Vector2i]

func _ready() -> void:
	
	room = []
	
	for i in width:
		var column = []
		for j in height:
			column.push_back(0)
		room.push_back(column)
	
	randomize()
	var start: Vector2i = Vector2i(randi_range(0, width - 1), randi_range(0, height - 1))
	var result = generate_path(start, path_size)
	print(result)
	
	display_room()


func generate_path(from: Vector2i, length: int) -> bool:
	var current: Vector2i = from
	if length == 0:
		return true
	var directions = DIRECTIONS.duplicate()
	directions.shuffle()
	for direction: Vector2i in directions:
		if (from.x + direction.x >= 0 and from.x + direction.x < width and from.y + direction.y >= 0 and from.y + direction.y < height) and not room[from.x + direction.x][from.y + direction.y]:
			room[from.x + direction.x][from.y + direction.y] = length
			if length >= 1:
				branches.push_back(current)
			if generate_path(from + direction, length - 1):
				return true
			else:
				branches.erase(current)
				room[from.x + direction.x][from.y + direction.y] = 0
	return false
	

func create_branches() -> void:
	branches.shuffle()
	var total_branches = 0
	for branch: Vector2i in branches:
		if generate_path(branch, randi_range(branch_length_min, branch_length_max)):
			total_branches += 1
			if total_branches >= branch_amount:
				break

func display_room() -> void:
	for y in height:
		var row = []
		for x in width:
			row.push_back(room[x][y])
		print(row)
