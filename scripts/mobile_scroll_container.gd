## Mobile-Friendly ScrollContainer
## Ensures scrolling works even when touch starts on child buttons
## This script makes the ScrollContainer intercept drag gestures at a higher priority
extends ScrollContainer

# Track touch/drag state
var _drag_start_pos: Vector2 = Vector2.ZERO
var _is_scrolling: bool = false
var _scroll_start_v: int = 0
var _is_touch_in_bounds: bool = false

## Pixels to move before we consider it scrolling (vs a tap/click)
## Lower values make scrolling more sensitive, higher values make buttons easier to click
@export var scroll_threshold: float = 5.0

func _ready() -> void:
	# Disable follow_focus for predictable mobile behavior
	follow_focus = false
	# Enable mouse filter to ensure we can process events
	mouse_filter = Control.MOUSE_FILTER_STOP

func _input(event: InputEvent) -> void:
	# Handle touch press/release
	if event is InputEventScreenTouch:
		var global_pos := event.position
		var local_pos := make_canvas_position_local(global_pos)
		var is_in_bounds := Rect2(Vector2.ZERO, size).has_point(local_pos)
		
		if event.pressed and is_in_bounds:
			_is_touch_in_bounds = true
			_drag_start_pos = local_pos
			_scroll_start_v = scroll_vertical
			_is_scrolling = false
		elif not event.pressed:
			_is_touch_in_bounds = false
			_is_scrolling = false
	
	# Also handle mouse for editor testing
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos := get_local_mouse_position()
		var is_in_bounds := Rect2(Vector2.ZERO, size).has_point(local_pos)
		
		if event.pressed and is_in_bounds:
			_is_touch_in_bounds = true
			_drag_start_pos = local_pos
			_scroll_start_v = scroll_vertical
			_is_scrolling = false
		elif not event.pressed:
			_is_touch_in_bounds = false
			_is_scrolling = false
	
	# Handle touch/mouse drag for scrolling (only if touch started in bounds)
	elif _is_touch_in_bounds:
		var current_pos: Vector2
		var is_drag := false
		
		if event is InputEventScreenDrag:
			var global_pos := event.position
			current_pos = make_canvas_position_local(global_pos)
			is_drag = true
		elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			current_pos = get_local_mouse_position()
			is_drag = true
		
		if is_drag:
			var drag_distance := _drag_start_pos.distance_to(current_pos)
			
			# If we've moved past the threshold, start scrolling
			if drag_distance > scroll_threshold or _is_scrolling:
				_is_scrolling = true
				
				# Calculate new scroll position
				var delta_y := current_pos.y - _drag_start_pos.y
				var new_scroll := _scroll_start_v - int(delta_y)
				
				# Clamp to valid scroll range
				var v_scrollbar := get_v_scroll_bar()
				scroll_vertical = clampi(new_scroll, int(v_scrollbar.min_value), int(v_scrollbar.max_value))
				
				# Consume the event to prevent buttons from processing it
				get_viewport().set_input_as_handled()
