## Test to verify toast notifications work correctly
extends Node

const ToastNotificationScene := preload("res://scenes/toast_notification.tscn")

var test_passed := false

func _ready() -> void:
	await get_tree().process_frame  # Wait for autoloads to initialize
	
	print("Testing toast notification system...")
	
	# Create a toast instance
	var toast: PanelContainer = ToastNotificationScene.instantiate()
	add_child(toast)
	
	# Test 1: Verify toast starts invisible
	assert(toast.visible == false, "Toast should start invisible")
	print("  ✓ Toast starts invisible")
	
	# Test 2: Show a toast with fishing skill
	var items_gained := {"raw_shrimp": 1}
	toast.show_action_completion("fishing", 10.0, items_gained)
	
	assert(toast.visible == true, "Toast should be visible after showing")
	print("  ✓ Toast becomes visible after showing")
	
	# Test 3: Verify toast has correct labels
	var skill_label: Label = toast.get_node("VBoxContainer/SkillLabel")
	var xp_label: Label = toast.get_node("VBoxContainer/XPLabel")
	var items_label: Label = toast.get_node("VBoxContainer/ItemsLabel")
	
	assert(skill_label != null, "Skill label should exist")
	assert(xp_label != null, "XP label should exist")
	assert(items_label != null, "Items label should exist")
	print("  ✓ All labels exist")
	
	# Test 4: Verify label content
	assert(skill_label.text == "Fishing", "Skill label should show 'Fishing'")
	assert(xp_label.text == "+10.0 XP", "XP label should show '+10.0 XP'")
	assert(items_label.visible == true, "Items label should be visible when items are gained")
	assert("Raw Shrimp" in items_label.text, "Items label should mention Raw Shrimp")
	print("  ✓ Labels show correct content")
	
	# Test 5: Show a toast with no items
	var toast2: PanelContainer = ToastNotificationScene.instantiate()
	add_child(toast2)
	toast2.show_action_completion("woodcutting", 25.0, {})
	
	var items_label2: Label = toast2.get_node("VBoxContainer/ItemsLabel")
	assert(items_label2.visible == false, "Items label should be hidden when no items are gained")
	print("  ✓ Items label hidden when no items gained")
	
	# Test 6: Test multiple skills
	var toast3: PanelContainer = ToastNotificationScene.instantiate()
	add_child(toast3)
	var multi_items := {"cooked_salmon": 1, "burnt_food": 1}
	toast3.show_action_completion("cooking", 90.0, multi_items)
	
	var items_label3: Label = toast3.get_node("VBoxContainer/ItemsLabel")
	assert(items_label3.visible == true, "Items label should be visible with multiple items")
	print("  ✓ Multiple items can be shown")
	
	print("  ✓ All toast notification tests passed!")
	test_passed = true
	
	# Wait a bit to see the toasts, then quit
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

func _process(_delta: float) -> void:
	# Monitor if test failed (e.g., assertion failed)
	if not test_passed:
		pass  # Test is still running
