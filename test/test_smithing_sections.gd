## Test script to validate smithing collapsible sections logic
extends Node

func _ready() -> void:
	print("\n=== SMITHING COLLAPSIBLE SECTIONS TEST ===")
	
	# Wait a frame for autoloads to initialize
	await get_tree().process_frame
	
	# Test 1: Verify smithing skill has exactly 50 methods
	print("\nTest 1: Checking smithing skill method count...")
	var smithing_skill: SkillData = GameManager.skills.get("smithing")
	assert(smithing_skill != null, "Smithing skill should exist")
	var total_methods := smithing_skill.training_methods.size()
	print("  Total methods: %d" % total_methods)
	assert(total_methods == 50, "Should have exactly 50 smithing methods")
	print("  ✓ Method count is correct")
	
	# Test 2: Verify section ranges are correct
	print("\nTest 2: Verifying section ranges...")
	var sections := [
		{"name": "Bars", "start": 0, "end": 7, "expected_count": 8},
		{"name": "Bronze", "start": 8, "end": 14, "expected_count": 7},
		{"name": "Iron", "start": 15, "end": 21, "expected_count": 7},
		{"name": "Steel", "start": 22, "end": 28, "expected_count": 7},
		{"name": "Mithril", "start": 29, "end": 35, "expected_count": 7},
		{"name": "Adamantite", "start": 36, "end": 42, "expected_count": 7},
		{"name": "Runite", "start": 43, "end": 49, "expected_count": 7},
	]
	
	for section in sections:
		var section_name: String = section["name"]
		var start: int = section["start"]
		var end: int = section["end"]
		var expected_count: int = section["expected_count"]
		var actual_count := end - start + 1
		
		print("  Section '%s': indices %d-%d (%d methods)" % [section_name, start, end, actual_count])
		assert(actual_count == expected_count, "Section %s should have %d methods" % [section_name, expected_count])
		
		# Verify all indices are within bounds
		for i in range(start, end + 1):
			assert(i < total_methods, "Index %d should be within total methods count" % i)
	
	print("  ✓ All section ranges are valid")
	
	# Test 3: Verify sections cover all methods exactly once
	print("\nTest 3: Checking section coverage...")
	var covered_indices: Dictionary = {}
	for section in sections:
		for i in range(section["start"], section["end"] + 1):
			assert(not covered_indices.has(i), "Index %d should not be covered by multiple sections" % i)
			covered_indices[i] = true
	
	assert(covered_indices.size() == total_methods, "All methods should be covered exactly once")
	print("  ✓ All %d methods are covered exactly once" % total_methods)
	
	# Test 4: Verify method IDs match expected patterns
	print("\nTest 4: Verifying method ID patterns...")
	
	# Check bars section
	var bar_ids := ["bronze_bar", "iron_bar", "silver_bar", "steel_bar", "gold_bar", "mithril_bar", "adamantite_bar", "runite_bar"]
	for i in range(8):
		var method: TrainingMethodData = smithing_skill.training_methods[i]
		print("  Index %d: %s" % [i, method.id])
		assert(method.id == bar_ids[i], "Bar at index %d should be %s, got %s" % [i, bar_ids[i], method.id])
	print("  ✓ Bar section IDs are correct")
	
	# Check bronze section
	var bronze_pattern := "bronze_"
	for i in range(8, 15):
		var method: TrainingMethodData = smithing_skill.training_methods[i]
		print("  Index %d: %s" % [i, method.id])
		assert(method.id.begins_with(bronze_pattern), "Bronze item at index %d should start with 'bronze_'" % i)
	print("  ✓ Bronze section IDs are correct")
	
	# Check runite section
	var runite_pattern := "runite_"
	for i in range(43, 50):
		var method: TrainingMethodData = smithing_skill.training_methods[i]
		print("  Index %d: %s" % [i, method.id])
		assert(method.id.begins_with(runite_pattern), "Runite item at index %d should start with 'runite_'" % i)
	print("  ✓ Runite section IDs are correct")
	
	print("\n=== ALL TESTS PASSED ===\n")
	
	# Exit
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
