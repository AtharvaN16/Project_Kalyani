extends Camera2D

const SPEED = 500
const ZOOM_SPEED = 0.1
const MIN_ZOOM = 0.2
const MAX_ZOOM = 2.0

func _process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	global_position += input_dir * SPEED * delta * (1.0 / zoom.x)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = (zoom + Vector2(ZOOM_SPEED, ZOOM_SPEED)).clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom - Vector2(ZOOM_SPEED, ZOOM_SPEED)).clamp(Vector2(MIN_ZOOM, MIN_ZOOM), Vector2(MAX_ZOOM, MAX_ZOOM))
