---
topic: "Godot Chunked Map System"
date: 2026-06-15
---

# Design Spec: High-Scale Chunked Map System

## 1. Objectives
- Support 500x500 tile world (16k x 16k pixels).
- Maintain 60 FPS using chunked loading/unloading.
- Seeded procedural generation (FastNoiseLite).
- Infinite potential (region-locked compute for distant AI).

## 2. Architecture
### MapManager (Map.gd)
- Entry point for the world.
- Handles chunk lifecycle (Load, Unload, Request).
- Stores `TileData` dictionary: `chunk_key -> Array[Array[Tile]]`.

### Chunk (Chunk.gd / Node2D)
- Individual TileMapLayer or custom rendering node.
- Handles its own procedural generation on `_ready()`.

### CameraSystem (Camera.gd)
- Pan/Zoom.
- Emits `position_changed` to trigger chunk updates in `MapManager`.

## 3. Data Schema
Tiles will be represented as an integer (Enum) to save memory:
- `0: Water`, `1: Grass`, `2: Forest`, etc.

## 4. Chunk Loading Logic
- `View Distance`: 1 chunk radius (9 chunks active).
- `Trigger`: Camera crosses a 32-tile boundary.
- `Async`: Use Godot's Threaded loading if frame drops occur.

## 5. Verification
- Debug overlay showing current Chunk ID.
- Print statements for load/unload events.
