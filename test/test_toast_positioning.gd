## Test to verify toast positioning at bottom of screen
extends Control

const ToastNotificationScene := preload("res://scenes/toast_notification.tscn")

var toast_container: VBoxContainer = null

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads to initialize
	
	print("Testing toast positioning...")
	
	# Set up viewport to match game dimensions
	get_viewport().size = Vector2i(720, 1280)
	
	# Create toast container exactly as main.gd does
	_create_toast_container()
	
	# Wait a bit then show test toasts
	await get_tree().create_timer(1.0).timeout
	_show_test_toasts()
	
	print("  ✓ Toast positioning test setup complete")
	print("  ✓ Check that toasts appear at bottom center of screen")
	
	# Keep running to see the toasts
	await get_tree().create_timer(10.0).timeout
	get_tree().quit()

func _create_toast_container() -> void:
	# Create a VBoxContainer to hold toast notifications
	toast_container = VBoxContainer.new()
	toast_container.name = "ToastContainer"
	toast_container.z_index = 200  # Ensure it's on top of everything
	toast_container.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Allow clicks to pass through
	
	# Position at bottom center of screen, right above the bottom
	toast_container.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	toast_container.offset_top = -150  # Right above the bottom
	toast_container.offset_bottom = -20  # Small padding from the bottom
	
	add_child(toast_container)
	
	print("  ✓ Toast container created at bottom center")
	print("    - offset_top: ", toast_container.offset_top)
	print("    - offset_bottom: ", toast_container.offset_bottom)

func _show_test_toasts() -> void:
	# Show a few test toasts
	var items_gained := {"raw_shrimp": 1}
	_show_toast("fishing", 10.0, items_gained)
	
	await get_tree().create_timer(1.0).timeout
	_show_toast("woodcutting", 25.0, {"logs": 1})
	
	await get_tree().create_timer(1.0).timeout
	_show_toast("cooking", 90.0, {"cooked_salmon": 1})

func _show_toast(skill_id: String, xp_gained: float, items_gained: Dictionary) -> void:
	if toast_container == null:
		return
	
	# Create a new toast instance
	var toast: PanelContainer = ToastNotificationScene.instantiate()
	toast_container.add_child(toast)
	
	# Move the new toast to the top (index 0) so it appears above older toasts
	# Toasts automatically manage their own lifecycle (fade out after 3s + 0.5s fade)
	# When a toast is removed, toasts above it naturally move down to fill the space
	toast_container.move_child(toast, 0)
	
	# Show the action completion
	toast.show_action_completion(skill_id, xp_gained, items_gained)
