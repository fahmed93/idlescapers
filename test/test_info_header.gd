## Test Info Header
## Verifies the sidebar has the new InfoHeader node
extends Node

func _ready() -> void:
	await get_tree().process_frame
	_run_tests()
	get_tree().quit()

func _run_tests() -> void:
	print("\n=== Info Header Tests ===\n")
	
	# Test 1: Check main.tscn for InfoHeader node
	print("Test 1: Verify main.tscn has InfoHeader")
	var main_scene = load("res://scenes/main.tscn")
	assert(main_scene != null, "main.tscn should load")
	
	# Load the scene to inspect its structure
	var scene_state: SceneState = main_scene.get_state()
	var info_header_found := false
	
	for i in range(scene_state.get_node_count()):
		var node_name: String = scene_state.get_node_name(i)
		if node_name == "InfoHeader":
			info_header_found = true
			print("  ✓ Found InfoHeader node")
			break
	
	assert(info_header_found, "main.tscn should have an InfoHeader node")
	print("  ✓ InfoHeader present in scene file\n")
	
	print("=== All Info Header Tests Passed! ===\n")
