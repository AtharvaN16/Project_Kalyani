extends Node

class_name TileTypes

enum Type {
	WATER,    # Blue
	GRASS,    # Light Green
	FOREST,   # Dark Green
	MOUNTAIN, # Gray
	HILL,     # Yellow-Green
	SWAMP,    # Olive
	TOWN_CENTER, # Orange
	SCOUT,       # Yellow
	SHROUD,      # Complete Dark (Never Explored)
	FOG          # Semi Dark (Explored but no vision)
}

const COLORS = {
	Type.WATER: Color(0.1, 0.4, 0.8),
	Type.GRASS: Color(0.4, 0.8, 0.2),
	Type.FOREST: Color(0.1, 0.4, 0.1),
	Type.MOUNTAIN: Color(0.5, 0.5, 0.5),
	Type.HILL: Color(0.6, 0.7, 0.2),
	Type.SWAMP: Color(0.3, 0.4, 0.2),
	Type.TOWN_CENTER: Color(1.0, 0.5, 0.0), # Orange
	Type.SCOUT: Color(1.0, 1.0, 0.0),       # Yellow
	Type.SHROUD: Color(0.05, 0.05, 0.05),   # Almost Black
	Type.FOG: Color(0.15, 0.15, 0.15)      # Dark Gray
}

const PROBABILITIES = {
	Type.WATER: 0.15,
	Type.GRASS: 0.40,
	Type.FOREST: 0.25,
	Type.MOUNTAIN: 0.12,
	Type.HILL: 0.05,
	Type.SWAMP: 0.03
}
