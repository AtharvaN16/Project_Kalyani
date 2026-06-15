extends Node2D

class_name Unit

var grid_pos: Vector2i
var vision_radius: int = 6
var is_selected: bool = false
var map_manager: Node2D

func setup(start_pos: Vector2i, manager: Node2D):
	grid_pos = start_pos
	map_manager = manager
	update_world_position()

func update_world_position():
	position = Vector2(grid_pos.x * 32 + 16, grid_pos.y * 32 + 16)

func move_to(target_pos: Vector2i):
	# Simple teleport move for now, pathfinding can come later
	grid_pos = target_pos
	update_world_position()
	map_manager.update_vision()
	map_manager.refresh_all_chunks()
