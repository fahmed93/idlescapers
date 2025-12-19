# Code Review Response

## Review Comment 1: Unused variable in test ✅ FIXED
**Location**: `test/test_time_to_level.gd`, line 53

**Issue**: The `effective_action_time` variable was calculated but never used.

**Resolution**: Removed the unused variable and added a comment explaining why we manually calculate instead of using the method.

**Commit**: Fix unused variable in test (5298711)

---

## Review Comment 2: Inconsistent time display (NOT AN ISSUE)
**Location**: `scripts/main.gd`, line 392

**Comment**: "Inconsistent time display: the training time label shows base action_time while the time to level calculation uses effective_action_time."

**Analysis**: This is intentional and correct:
- Line 392: `training_time_label.text = "%.1fs / %.1fs" % [GameManager.training_progress, method.action_time]`
  - Shows progress through the **current individual action**
  - `training_progress` accumulates using `modified_delta` (which includes speed bonuses)
  - `method.action_time` is the base completion threshold
  - This shows real-time progress: e.g., "1.8s / 2.0s" means the action will complete when progress reaches 2.0s
  
- Time to level calculation uses `effective_action_time`:
  - This is correct because it needs to predict **future actions**
  - Each future action will take `effective_action_time` seconds

**Example**:
With 50% speed bonus:
- Current action shows: "1.8s / 2.0s" (90% complete)
- But it only took ~1.33s of real time to get to 1.8s progress (due to speed bonus)
- Time to level correctly uses 1.33s per action for future predictions

**Conclusion**: The existing behavior is correct. The training_time_label shows progress through the base action threshold, while time predictions use effective time. This is consistent with how GameManager._process() works.

---

## Review Comment 3: Magic numbers (CONSISTENT WITH CODEBASE)
**Location**: `scripts/main.gd`, lines 414-415

**Comment**: "Magic number 60 appears multiple times. Consider defining constants."

**Analysis**: The existing codebase already uses magic numbers for time conversions:

**In `resources/skills/training_method_data.gd`** (lines 84-93):
```gdscript
if seconds < 60:
    return "%.0fs left" % seconds
elif seconds < 3600:
    var mins := int(seconds / 60)
    var secs := int(seconds) % 60
    return "%dm %ds left" % [mins, secs]
else:
    var hours := int(seconds / 3600)
    var mins := int((int(seconds) % 3600) / 60)
    return "%dh %dm left" % [hours, mins]
```

**In our implementation** (lines 414-436):
```gdscript
if seconds < 60:
    return "%.0fs" % seconds
elif seconds < 3600:
    var mins := int(seconds / 60)
    # ... etc
```

**Conclusion**: For consistency with the existing codebase, we follow the same pattern. If constants were to be added, it should be done as a separate refactoring PR that updates both `TrainingMethodData.format_time_remaining()` and `Main._format_time_to_level()` together, possibly extracting a shared utility function.

**Recommendation for future work**:
```gdscript
# Could create a global time utility:
# autoload/time_formatter.gd
class_name TimeFormatter
extends Node

const SECONDS_PER_MINUTE := 60
const SECONDS_PER_HOUR := 3600
const SECONDS_PER_DAY := 86400

static func format_duration(seconds: float, include_suffix: bool = false) -> String:
    # Shared implementation
    pass
```

But this is beyond the scope of the current PR which focuses on adding time to level display.

---

## Summary

- ✅ Fixed: Removed unused variable in test
- ℹ️ No change needed: Training time label behavior is correct as-is
- ℹ️ No change needed: Magic numbers are consistent with existing codebase patterns

All review comments have been addressed or explained. The implementation follows existing code patterns and conventions.
