extends Node

class_name TileSetGenerator

static func create_placeholder_tileset() -> TileSet:
	var tileset = TileSet.new()
	tileset.tile_size = Vector2i(32, 32)
	
	var source = TileSetAtlasSource.new()
	# We'll create a single large texture with different colored squares
	var image = Image.create(512, 32, false, Image.FORMAT_RGBA8)
	
	# Fill different regions with terrain colors
	var types = [
		TileTypes.Type.WATER,
		TileTypes.Type.GRASS,
		TileTypes.Type.FOREST,
		TileTypes.Type.MOUNTAIN,
		TileTypes.Type.HILL,
		TileTypes.Type.SWAMP,
		TileTypes.Type.TOWN_CENTER, # 6
		TileTypes.Type.SHROUD,      # 7
		TileTypes.Type.FOG          # 8
	]
	
	for i in range(types.size()):
		var color = TileTypes.COLORS[types[i]]
		image.fill_rect(Rect2i(i * 32, 0, 32, 32), color)
	
	var texture = ImageTexture.create_from_image(image)
	source.texture = texture
	source.texture_region_size = Vector2i(32, 32)
	
	# Create tiles for each color
	for i in range(types.size()):
		source.create_tile(Vector2i(i, 0))
	
	tileset.add_source(source, 0)
	return tileset
