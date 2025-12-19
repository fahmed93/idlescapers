## Test ScrollContainer Structure
## Verifies the MainContent is wrapped in a ScrollContainer for sidebar expansion fix
extends Node

func _ready() -> void:
	await get_tree().process_frame
	_run_tests()
	get_tree().quit()

func _run_tests() -> void:
	print("\n=== ScrollContainer Structure Tests ===\n")
	
	# Test 1: Check main.tscn for MainContentScroll node
	print("Test 1: Verify main.tscn has MainContentScroll ScrollContainer")
	var main_scene = load("res://scenes/main.tscn")
	assert(main_scene != null, "main.tscn should load")
	
	# Load the scene to inspect its structure
	var scene_state: SceneState = main_scene.get_state()
	var scroll_container_found := false
	var main_content_found := false
	var main_content_parent := ""
	
	for i in range(scene_state.get_node_count()):
		var node_name: String = scene_state.get_node_name(i)
		var node_parent: String = scene_state.get_node_path(i, true)
		
		if node_name == "MainContentScroll":
			scroll_container_found = true
			var node_type: StringName = scene_state.get_node_type(i)
			assert(str(node_type) == "ScrollContainer", "MainContentScroll should be a ScrollContainer")
			print("  ✓ Found MainContentScroll ScrollContainer")
			
		elif node_name == "MainContent":
			main_content_found = true
			main_content_parent = node_parent
			print("  ✓ Found MainContent node with parent: %s" % node_parent)
	
	assert(scroll_container_found, "main.tscn should have a MainContentScroll node")
	assert(main_content_found, "main.tscn should have a MainContent node")
	assert(main_content_parent.contains("MainContentScroll"), "MainContent should be a child of MainContentScroll")
	print("  ✓ MainContent is properly nested in ScrollContainer\n")
	
	# Test 2: Verify the scene can be instantiated
	print("Test 2: Verify scene can be instantiated")
	var main_instance = main_scene.instantiate()
	assert(main_instance != null, "main.tscn should instantiate")
	
	# Verify nodes exist in the instantiated scene
	var scroll_node = main_instance.get_node_or_null("HSplitContainer/MainContentScroll")
	var content_node = main_instance.get_node_or_null("HSplitContainer/MainContentScroll/MainContent")
	
	assert(scroll_node != null, "MainContentScroll should exist in instantiated scene")
	assert(content_node != null, "MainContent should exist in instantiated scene")
	assert(scroll_node is ScrollContainer, "MainContentScroll should be a ScrollContainer")
	print("  ✓ Scene instantiates correctly with ScrollContainer\n")
	
	main_instance.queue_free()
	
	print("=== All ScrollContainer Structure Tests Passed! ===\n")
