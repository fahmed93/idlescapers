## Test Sidebar Structure
## Verifies the sidebar has proper headers (Player and Skills)
extends Node

func _ready() -> void:
	await get_tree().process_frame
	_run_tests()
	get_tree().quit()

func _run_tests() -> void:
	print("\n=== Sidebar Structure Tests ===\n")
	
	# Test 1: Check main.tscn for PlayerHeader node
	print("Test 1: Verify main.tscn has PlayerHeader")
	var main_scene = load("res://scenes/main.tscn")
	assert(main_scene != null, "main.tscn should load")
	
	# Load the scene to inspect its structure
	var scene_state: SceneState = main_scene.get_state()
	var player_header_found := false
	var skills_header_found := false
	
	for i in range(scene_state.get_node_count()):
		var node_name: String = scene_state.get_node_name(i)
		if node_name == "PlayerHeader":
			player_header_found = true
			print("  ✓ Found PlayerHeader node")
		elif node_name == "SkillsHeader":
			skills_header_found = true
			print("  ✓ Found SkillsHeader node")
	
	assert(player_header_found, "main.tscn should have a PlayerHeader node")
	assert(skills_header_found, "main.tscn should have a SkillsHeader node")
	print("  ✓ Both headers present in scene file\n")
	
	print("=== All Sidebar Structure Tests Passed! ===\n")
