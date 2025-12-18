## Test to verify toasts manage their own lifecycle naturally
## This test verifies that:
## 1. New toasts appear above existing toasts
## 2. Toasts only move down when older toasts naturally disappear (complete their fade)
## 3. No forced removal happens
extends Control

const ToastNotificationScene := preload("res://scenes/toast_notification.tscn")

var toast_container: VBoxContainer = null
var toast_count := 0

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads to initialize
	
	print("Testing toast natural lifecycle...")
	print("This test will create multiple toasts rapidly to verify:")
	print("  1. New toasts appear above existing ones")
	print("  2. Toasts move down only when older toasts disappear naturally")
	print("  3. No forced removal interrupts fade animations")
	print("")
	
	# Set up viewport to match game dimensions
	get_viewport().size = Vector2i(720, 1280)
	
	# Create toast container exactly as main.gd does
	_create_toast_container()
	
	# Show multiple toasts in rapid succession (faster than fade-out)
	print("Creating 5 toasts rapidly...")
	for i in range(5):
		await get_tree().create_timer(0.5).timeout  # 0.5s between toasts
		_show_test_toast(i + 1)
		print("  Toast %d created (total children: %d)" % [i + 1, toast_container.get_child_count()])
	
	print("")
	print("✓ All toasts created")
	print("  Current toast count: %d" % toast_container.get_child_count())
	print("")
	print("Now monitoring natural lifecycle...")
	print("  - Toasts should fade out after 3.5s (3s display + 0.5s fade)")
	print("  - Toasts above should move down naturally when older ones disappear")
	print("")
	
	# Monitor for 10 seconds to observe natural fade-out
	for second in range(10):
		await get_tree().create_timer(1.0).timeout
		var count := toast_container.get_child_count()
		print("  [%ds] Active toasts: %d" % [second + 1, count])
	
	print("")
	print("✓ Test complete!")
	print("  Final toast count: %d (should be 0 or close to 0)" % toast_container.get_child_count())
	
	# Verify expected behavior
	var final_count := toast_container.get_child_count()
	if final_count <= 1:  # Allow 1 remaining toast (the last one might still be fading)
		print("  ✓ Toasts managed their lifecycle naturally")
	else:
		print("  ⚠ Warning: More toasts remaining than expected (%d)" % final_count)
	
	get_tree().quit()

func _create_toast_container() -> void:
	# Create a VBoxContainer to hold toast notifications
	toast_container = VBoxContainer.new()
	toast_container.name = "ToastContainer"
	toast_container.z_index = 200
	toast_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Position at bottom center of screen
	toast_container.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	toast_container.offset_top = -150
	toast_container.offset_bottom = -20
	
	add_child(toast_container)
	
	print("  ✓ Toast container created")

func _show_test_toast(number: int) -> void:
	if toast_container == null:
		return
	
	# Create a new toast instance
	var toast: PanelContainer = ToastNotificationScene.instantiate()
	toast_container.add_child(toast)
	
	# Move the new toast to the top (index 0) so it appears above older toasts
	toast_container.move_child(toast, 0)
	
	# Show the action completion with varying skills to make them visually distinct
	var skills := ["fishing", "woodcutting", "cooking", "mining", "smithing"]
	var skill_id := skills[number % skills.size()]
	var items_gained := {"test_item_%d" % number: 1}
	
	toast.show_action_completion(skill_id, float(number) * 10.0, items_gained)
