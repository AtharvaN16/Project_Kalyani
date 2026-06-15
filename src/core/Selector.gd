extends Node2D

var is_dragging = false
var drag_start = Vector2.ZERO
var drag_end = Vector2.ZERO
var selection_color = Color(0, 1, 0, 0.3)
var border_color = Color(0, 1, 0, 0.7)

signal area_selected(rect: Rect2)
signal point_selected(pos: Vector2)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				drag_start = get_global_mouse_position()
				drag_end = drag_start
			else:
				is_dragging = false
				var final_rect = get_rect_normalized()
				if final_rect.size.length() < 5:
					point_selected.emit(drag_start)
				else:
					area_selected.emit(final_rect)
				queue_redraw()

	if event is InputEventMouseMotion and is_dragging:
		drag_end = get_global_mouse_position()
		queue_redraw()

func get_rect_normalized() -> Rect2:
	return Rect2(drag_start, Vector2.ZERO).expand(drag_end)

func _draw():
	if is_dragging:
		draw_rect(get_rect_normalized(), selection_color, true)
		draw_rect(get_rect_normalized(), border_color, false, 2.0)
