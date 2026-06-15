extends Node2D

# --- Constants ---
const CHUNK_SIZE = 32 # Tiles per chunk (matches Godot TileMap optimization)
const TILE_SIZE = 32  # Pixels per tile
const WORLD_SIZE = 500 # Total tiles across
const VIEW_DISTANCE = 1 # Chunks around player (3x3 grid)

# --- State ---
var seed_value = 12345
var noise = FastNoiseLite.new()
var tileset_resource: TileSet
var loaded_chunks = {} # chunk_key (Vector2i) -> TileMapLayer
var tile_data = {}     # chunk_key -> Array (The "Memory" of the world)
var revealed_tiles = {} # global_tile_pos -> bool (Fog of War persistence)
var buildings = {}      # global_tile_pos -> int (Building Type)

# --- Nodes ---
@onready var camera = $Camera2D

func _ready():
	tileset_resource = TileSetGenerator.create_placeholder_tileset()
	setup_noise()
	
	# Place Town Center at map center
	var center = Vector2i(WORLD_SIZE / 2, WORLD_SIZE / 2)
	buildings[center] = TileTypes.Type.TOWN_CENTER
	reveal_area(center, 10) # Reveal 10-tile radius around TC
	
	# Move camera to TC
	camera.global_position = Vector2(center.x * TILE_SIZE, center.y * TILE_SIZE)
	
	update_chunks()

func setup_noise():
	noise.seed = seed_value
	noise.frequency = 0.05
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

func _process(_delta):
	# Check if camera has moved into a new chunk
	var current_chunk = get_chunk_coords(camera.global_position)
	if not loaded_chunks.has(current_chunk):
		update_chunks()

func get_chunk_coords(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(world_pos.x / (CHUNK_SIZE * TILE_SIZE)),
		floor(world_pos.y / (CHUNK_SIZE * TILE_SIZE))
	)

func update_chunks():
	var center_chunk = get_chunk_coords(camera.global_position)
	var needed_chunks = []
	
	# Determine which chunks should be loaded
	for x in range(-VIEW_DISTANCE, VIEW_DISTANCE + 1):
		for y in range(-VIEW_DISTANCE, VIEW_DISTANCE + 1):
			needed_chunks.append(center_chunk + Vector2i(x, y))
	
	# Unload distant chunks
	for key in loaded_chunks.keys():
		if not key in needed_chunks:
			unload_chunk(key)
			
	# Load new chunks
	for key in needed_chunks:
		if not loaded_chunks.has(key):
			load_chunk(key)

func load_chunk(coords: Vector2i):
	# Boundary check
	if coords.x < 0 or coords.y < 0 or coords.x >= WORLD_SIZE/CHUNK_SIZE or coords.y >= WORLD_SIZE/CHUNK_SIZE:
		return

	var layer = TileMapLayer.new()
	layer.name = "Chunk_%d_%d" % [coords.x, coords.y]
	layer.tile_set = tileset_resource
	layer.position = Vector2(coords.x * CHUNK_SIZE * TILE_SIZE, coords.y * CHUNK_SIZE * TILE_SIZE)
	
	# Generate or retrieve data
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
	# Basic mapping: -1.0 to 1.0
	if val < -0.2: return TileTypes.Type.WATER
	if val < 0.2: return TileTypes.Type.GRASS
	if val < 0.4: return TileTypes.Type.HILL
	if val < 0.6: return TileTypes.Type.FOREST
	if val < 0.8: return TileTypes.Type.SWAMP
	return TileTypes.Type.MOUNTAIN

func reveal_area(center: Vector2i, radius: int):
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			var pos = center + Vector2i(x, y)
			if pos.x >= 0 and pos.y >= 0 and pos.x < WORLD_SIZE and pos.y < WORLD_SIZE:
				# Circle reveal
				if Vector2(pos).distance_to(Vector2(center)) <= radius:
					revealed_tiles[pos] = true

func render_chunk(layer: TileMapLayer, coords: Vector2i):
	var data = tile_data[coords]
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var global_pos = Vector2i((coords.x * CHUNK_SIZE) + x, (coords.y * CHUNK_SIZE) + y)
			
			# Fog of War Check
			if revealed_tiles.has(global_pos):
				# Check for building first
				if buildings.has(global_pos):
					layer.set_cell(Vector2i(x, y), 0, Vector2i(6, 0)) # Town Center tile index
				else:
					var tile_type = data[x][y]
					layer.set_cell(Vector2i(x, y), 0, Vector2i(tile_type, 0))
			else:
				# Set hidden/shroud tile
				layer.set_cell(Vector2i(x, y), 0, Vector2i(7, 0)) # Shroud tile index

func unload_chunk(coords: Vector2i):
	if loaded_chunks.has(coords):
		loaded_chunks[coords].queue_free()
		loaded_chunks.erase(coords)

func reveal_tile(global_pos: Vector2i):
	revealed_tiles[global_pos] = true
	var chunk_coords = Vector2i(global_pos.x / CHUNK_SIZE, global_pos.y / CHUNK_SIZE)
	if loaded_chunks.has(chunk_coords):
		# Re-render local part of the chunk
		var local_x = global_pos.x % CHUNK_SIZE
		var local_y = global_pos.y % CHUNK_SIZE
		# Check for building
		if buildings.has(global_pos):
			loaded_chunks[chunk_coords].set_cell(Vector2i(local_x, local_y), 0, Vector2i(6, 0))
		else:
			var tile_type = tile_data[chunk_coords][local_x][local_y]
			loaded_chunks[chunk_coords].set_cell(Vector2i(local_x, local_y), 0, Vector2i(tile_type, 0))
