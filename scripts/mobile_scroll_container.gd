## Mobile-Friendly ScrollContainer
## Ensures scrolling works even when touch starts on child buttons
## This script makes the ScrollContainer intercept drag gestures at a higher priority
extends ScrollContainer

# Track touch/drag state
var _drag_start_pos: Vector2 = Vector2.ZERO
var _is_scrolling: bool = false
var _scroll_start_v: int = 0
const SCROLL_THRESHOLD := 5.0  # Pixels to move before we consider it scrolling

func _ready() -> void:
	# Disable follow_focus for predictable mobile behavior
	follow_focus = false
	# Enable mouse filter to ensure we can process events
	mouse_filter = Control.MOUSE_FILTER_STOP

func _input(event: InputEvent) -> void:
	# Only handle events if they're within our bounds
	if not get_global_rect().has_point(get_global_mouse_position()):
		return
	
	# Handle touch press/release
	if event is InputEventScreenTouch or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		if event.pressed:
			_drag_start_pos = event.position if event is InputEventScreenTouch else get_local_mouse_position()
			_scroll_start_v = scroll_vertical
			_is_scrolling = false
		else:
			_is_scrolling = false
	
	# Handle touch/mouse drag for scrolling
	elif (event is InputEventScreenDrag) or (event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		var current_pos: Vector2
		if event is InputEventScreenDrag:
			current_pos = event.position
		else:
			current_pos = get_local_mouse_position()
		
		var drag_distance := _drag_start_pos.distance_to(current_pos)
		
		# If we've moved past the threshold, start scrolling
		if drag_distance > SCROLL_THRESHOLD or _is_scrolling:
			_is_scrolling = true
			
			# Calculate new scroll position
			var delta_y := current_pos.y - _drag_start_pos.y
			scroll_vertical = _scroll_start_v - int(delta_y)
			
			# Consume the event to prevent buttons from processing it
			get_viewport().set_input_as_handled()
