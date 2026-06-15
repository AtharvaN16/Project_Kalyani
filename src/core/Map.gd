extends Node2D

# --- Constants ---
const CHUNK_SIZE = 32 # Tiles per chunk
const TILE_SIZE = 32  # Pixels per tile
const WORLD_SIZE = 500 # Total tiles across
const VIEW_DISTANCE = 1 # Chunks around player (3x3 grid)

# --- State ---
var seed_value = 12345
var noise = FastNoiseLite.new()
var tileset_resource: TileSet
var loaded_chunks = {}   # chunk_key (Vector2i) -> TileMapLayer
var tile_data = {}       # chunk_key -> Array
var explored_tiles = {}  # global_tile_pos -> bool (Revealed once)
var visible_tiles = {}   # global_tile_pos -> bool (Currently in vision)
var buildings = {}       # global_tile_pos -> int (Building Type)
var units = []           # Array of Unit objects
var selected_units = []  # Multi-selection support

# --- Nodes ---
@onready var camera = $Camera2D
@onready var selector = $Selector
@onready var hud_label = get_node("../HUD/Control/SelectionLabel")

func _ready():
	tileset_resource = TileSetGenerator.create_placeholder_tileset()
	setup_noise()
	
	var center = Vector2i(WORLD_SIZE / 2, WORLD_SIZE / 2)
	place_building(center, 4, TileTypes.Type.TOWN_CENTER)
	
	# Spawn Scout
	spawn_unit(center + Vector2i(5, 5))
	
	# Connect Selector signals
	selector.point_selected.connect(_on_point_selected)
	selector.area_selected.connect(_on_area_selected)
	
	update_vision()
	camera.global_position = Vector2(center.x * TILE_SIZE, center.y * TILE_SIZE)
	update_chunks()

func setup_noise():
	noise.seed = seed_value
	noise.frequency = 0.05
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

func _process(_delta):
	var current_chunk = get_chunk_coords(camera.global_position)
	if not loaded_chunks.has(current_chunk):
		update_chunks()

func get_chunk_coords(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(world_pos.x / (CHUNK_SIZE * TILE_SIZE)),
		floor(world_pos.y / (CHUNK_SIZE * TILE_SIZE))
	)

func spawn_unit(pos: Vector2i):
	var scout = Unit.new()
	scout.setup(pos, self)
	add_child(scout)
	units.append(scout)

func _on_point_selected(pos: Vector2):
	var grid_click = Vector2i(floor(pos.x / TILE_SIZE), floor(pos.y / TILE_SIZE))
	
	clear_selection()
	
	# Check for unit
	for u in units:
		if u.grid_pos == grid_click:
			select_unit(u)
			update_hud_text("Scout Selected")
			return
			
	# Check for building
	if buildings.has(grid_click):
		update_hud_text("Town Center Selected")
		return
		
	update_hud_text("Nothing Selected")

func _on_area_selected(rect: Rect2):
	clear_selection()
	var selected_count = 0
	
	for u in units:
		if rect.has_point(u.global_position):
			select_unit(u)
			selected_count += 1
			
	if selected_count > 0:
		update_hud_text(str(selected_count) + " Units Selected")
	else:
		update_hud_text("Nothing Selected")

func select_unit(unit: Unit):
	unit.is_selected = true
	selected_units.append(unit)

func clear_selection():
	for u in selected_units:
		u.is_selected = false
	selected_units.clear()

func update_hud_text(text: String):
	if hud_label:
		hud_label.text = text

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var mouse_pos = get_global_mouse_position()
			var grid_click = Vector2i(floor(mouse_pos.x / TILE_SIZE), floor(mouse_pos.y / TILE_SIZE))
			
			if not selected_units.is_empty():
				for u in selected_units:
					u.move_to(grid_click)
				print("Moving Selection to ", grid_click)

func update_chunks():
	var center_chunk = get_chunk_coords(camera.global_position)
	var needed_chunks = []
	
	for x in range(-VIEW_DISTANCE, VIEW_DISTANCE + 1):
		for y in range(-VIEW_DISTANCE, VIEW_DISTANCE + 1):
			needed_chunks.append(center_chunk + Vector2i(x, y))
	
	for key in loaded_chunks.keys():
		if not key in needed_chunks:
			unload_chunk(key)
			
	for key in needed_chunks:
		if not loaded_chunks.has(key):
			load_chunk(key)

func load_chunk(coords: Vector2i):
	if coords.x < 0 or coords.y < 0 or coords.x >= WORLD_SIZE/CHUNK_SIZE or coords.y >= WORLD_SIZE/CHUNK_SIZE:
		return

	var layer = TileMapLayer.new()
	layer.name = "Chunk_%d_%d" % [coords.x, coords.y]
	layer.tile_set = tileset_resource
	layer.position = Vector2(coords.x * CHUNK_SIZE * TILE_SIZE, coords.y * CHUNK_SIZE * TILE_SIZE)
	
	if not tile_data.has(coords):
		generate_chunk_data(coords)
		
	render_chunk(layer, coords)
	add_child(layer)
	loaded_chunks[coords] = layer

func generate_chunk_data(coords: Vector2i):
	var data = []
	for x in range(CHUNK_SIZE):
		var row = []
		for y in range(CHUNK_SIZE):
			var global_x = (coords.x * CHUNK_SIZE) + x
			var global_y = (coords.y * CHUNK_SIZE) + y
			var val = noise.get_noise_2d(global_x, global_y)
			row.append(get_tile_type_from_noise(val))
		data.append(row)
	tile_data[coords] = data

func get_tile_type_from_noise(val: float) -> int:
	if val < -0.2: return TileTypes.Type.WATER
	if val < 0.2: return TileTypes.Type.GRASS
	if val < 0.4: return TileTypes.Type.HILL
	if val < 0.6: return TileTypes.Type.FOREST
	if val < 0.8: return TileTypes.Type.SWAMP
	return TileTypes.Type.MOUNTAIN

func place_building(top_left: Vector2i, size: int, type: int):
	for x in range(size):
		for y in range(size):
			var pos = top_left + Vector2i(x, y)
			buildings[pos] = type

func update_vision():
	visible_tiles.clear()
	
	for pos in buildings.keys():
		reveal_area(pos, 8) 
		
	for u in units:
		reveal_area(u.grid_pos, u.vision_radius)

func reveal_area(center: Vector2i, radius: int):
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			var pos = center + Vector2i(x, y)
			if pos.x >= 0 and pos.y >= 0 and pos.x < WORLD_SIZE and pos.y < WORLD_SIZE:
				if Vector2(pos).distance_to(Vector2(center)) <= radius:
					explored_tiles[pos] = true
					visible_tiles[pos] = true

func refresh_all_chunks():
	for key in loaded_chunks.keys():
		render_chunk(loaded_chunks[key], key)

func render_chunk(layer: TileMapLayer, coords: Vector2i):
	layer.clear()
	var data = tile_data[coords]
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var global_pos = Vector2i((coords.x * CHUNK_SIZE) + x, (coords.y * CHUNK_SIZE) + y)
			
			if visible_tiles.has(global_pos):
				# FULL VISION
				if buildings.has(global_pos):
					layer.set_cell(Vector2i(x, y), 0, Vector2i(6, 0)) # TC index
				else:
					layer.set_cell(Vector2i(x, y), 0, Vector2i(data[x][y], 0))
			elif explored_tiles.has(global_pos):
				layer.set_cell(Vector2i(x, y), 0, Vector2i(9, 0)) # Fog index
			else:
				layer.set_cell(Vector2i(x, y), 0, Vector2i(8, 0)) # Shroud index

func unload_chunk(coords: Vector2i):
	if loaded_chunks.has(coords):
		loaded_chunks[coords].queue_free()
		loaded_chunks.erase(coords)
