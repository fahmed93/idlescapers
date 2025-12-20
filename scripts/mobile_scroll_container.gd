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

## Pixels to move before we consider it scrolling (vs a tap/click)
## Lower values make scrolling more sensitive, higher values make buttons easier to click
@export var scroll_threshold: float = 10.0

func _ready() -> void:
	# Disable follow_focus for predictable mobile behavior
	follow_focus = false
	# Enable mouse filter to ensure we can process events
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event: InputEvent) -> void:
	# Handle touch press
	if event is InputEventScreenTouch:
		if event.pressed:
			# Touch started
			_is_dragging = true
			_is_scrolling = false
			_drag_start_pos = event.position
			_last_drag_pos = event.position
			_scroll_start_v = scroll_vertical
			_scroll_start_h = scroll_horizontal
		else:
			# Touch released
			_is_dragging = false
			_is_scrolling = false
	
	# Handle mouse button for editor testing
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Mouse button pressed
			_is_dragging = true
			_is_scrolling = false
			_drag_start_pos = event.position
			_last_drag_pos = event.position
			_scroll_start_v = scroll_vertical
			_scroll_start_h = scroll_horizontal
		else:
			# Mouse button released
			_is_dragging = false
			_is_scrolling = false
	
	# Handle touch/mouse drag for scrolling
	elif _is_dragging:
		var current_pos: Vector2 = Vector2.ZERO
		var is_drag := false
		
		if event is InputEventScreenDrag:
			current_pos = event.position
			is_drag = true
		elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			current_pos = event.position
			is_drag = true
		
		if is_drag:
			var drag_distance := _drag_start_pos.distance_to(current_pos)
			
			# If we've moved past the threshold, start scrolling
			if drag_distance > scroll_threshold or _is_scrolling:
				if not _is_scrolling:
					_is_scrolling = true
					# Accept the event to start scrolling mode
					accept_event()
				
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
				
				# Consume the event to prevent buttons from processing it
				accept_event()
