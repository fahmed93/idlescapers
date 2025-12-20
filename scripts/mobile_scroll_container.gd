## Mobile-Friendly ScrollContainer
## Ensures scrolling works even when touch starts on child buttons
## This script makes the ScrollContainer intercept drag gestures at a higher priority
extends ScrollContainer

# Track touch/drag state
var _drag_start_pos: Vector2 = Vector2.ZERO
var _is_scrolling: bool = false
var _scroll_start_v: int = 0
var _scroll_start_h: int = 0
var _is_dragging: bool = false
var _last_drag_pos: Vector2 = Vector2.ZERO
var _is_touch_in_bounds: bool = false

## Pixels to move before we consider it scrolling (vs a tap/click)
## Lower values make scrolling more sensitive, higher values make buttons easier to click
@export var scroll_threshold: float = 10.0

func _ready() -> void:
	# Disable follow_focus for predictable mobile behavior
	follow_focus = false
	# Enable mouse filter to ensure we can process events
	mouse_filter = Control.MOUSE_FILTER_STOP

## Helper to start drag/press
func _start_drag(position: Vector2) -> void:
	_is_dragging = true
	_is_scrolling = false
	_drag_start_pos = position
	_last_drag_pos = position
	_scroll_start_v = scroll_vertical
	_scroll_start_h = scroll_horizontal

## Helper to end drag/press
func _end_drag() -> void:
	_is_dragging = false
	_is_scrolling = false
	_is_touch_in_bounds = false

## Check if a global position is within this control's bounds
func _is_position_in_bounds(global_pos: Vector2) -> bool:
	var local_pos := global_pos - global_position
	var rect := Rect2(Vector2.ZERO, size)
	return rect.has_point(local_pos)

## Use _input to catch events BEFORE child controls (like buttons) consume them
## This is key to making scroll work even when starting a drag on a button
func _input(event: InputEvent) -> void:
	# Handle touch press
	if event is InputEventScreenTouch:
		if event.pressed:
			# Check if touch is within our bounds
			if _is_position_in_bounds(event.position):
				_is_touch_in_bounds = true
				var local_pos := event.position - global_position
				_start_drag(local_pos)
		else:
			# Touch released
			if _is_touch_in_bounds:
				_end_drag()
	
	# Handle mouse button for editor testing
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if _is_position_in_bounds(event.position):
				_is_touch_in_bounds = true
				var local_pos := event.position - global_position
				_start_drag(local_pos)
		else:
			if _is_touch_in_bounds:
				_end_drag()
	
	# Handle touch/mouse drag for scrolling
	elif _is_dragging and _is_touch_in_bounds:
		var global_pos: Vector2
		var has_valid_event := false
		
		# Get current position based on event type
		if event is InputEventScreenDrag:
			global_pos = event.position
			has_valid_event = true
		elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			global_pos = event.position
			has_valid_event = true
		
		if not has_valid_event:
			return
		
		# Convert to local coordinates
		var current_pos := global_pos - global_position
		
		# Process the drag
		var drag_distance := _drag_start_pos.distance_to(current_pos)
		
		# If we've moved past the threshold, start scrolling
		if drag_distance > scroll_threshold or _is_scrolling:
			if not _is_scrolling:
				_is_scrolling = true
				# Mark event as handled in the viewport to prevent buttons from getting click events
				get_viewport().set_input_as_handled()
			
			# Calculate delta from last position for smooth incremental scrolling
			var delta := current_pos - _last_drag_pos
			_last_drag_pos = current_pos
			
			# Update vertical scroll if enabled
			if vertical_scroll_mode != ScrollContainer.SCROLL_MODE_DISABLED:
				var v_scrollbar := get_v_scroll_bar()
				if v_scrollbar:
					var new_scroll_v := scroll_vertical - int(delta.y)
					scroll_vertical = clampi(new_scroll_v, int(v_scrollbar.min_value), int(v_scrollbar.max_value))
			
			# Update horizontal scroll if enabled
			if horizontal_scroll_mode != ScrollContainer.SCROLL_MODE_DISABLED:
				var h_scrollbar := get_h_scroll_bar()
				if h_scrollbar:
					var new_scroll_h := scroll_horizontal - int(delta.x)
					scroll_horizontal = clampi(new_scroll_h, int(h_scrollbar.min_value), int(h_scrollbar.max_value))
			
			# Mark event as handled to prevent buttons from processing it
			get_viewport().set_input_as_handled()
