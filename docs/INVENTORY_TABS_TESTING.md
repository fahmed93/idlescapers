# Manual Testing Guide: Inventory Tabs

## Purpose
This guide provides step-by-step instructions for manually testing the inventory tabs feature to ensure it works correctly before merging.

## Prerequisites
- Godot 4.5+ installed
- Project loaded in Godot editor
- A test character with some inventory items

## Test Scenarios

### 1. Basic Tab Creation
**Steps:**
1. Start the game and select/create a character
2. Click on "Inventory" in the sidebar
3. Verify "Main" tab is visible at the top of inventory
4. Click the "+" button next to the tab bar
5. Verify a new tab appears (e.g., "Tab 1")
6. Click the new tab
7. Verify it becomes selected (visually highlighted)
8. Verify the inventory grid is empty

**Expected Results:**
- Main tab always exists
- New tabs can be created
- Clicking tabs switches the view
- Empty tabs show no items

### 2. Add Items to Different Tabs
**Steps:**
1. Train a skill that produces items (e.g., Fishing → catch raw shrimp)
2. Items should appear in Main tab by default
3. Create a new tab called "Fish"
4. Stay on Main tab, verify items are visible
5. Switch to "Fish" tab, verify it's empty

**Expected Results:**
- Items gained during gameplay go to currently selected tab
- Different tabs maintain separate item lists
- Switching tabs updates the display correctly

### 3. Drag and Drop Between Tabs
**Steps:**
1. Ensure Main tab has some items (e.g., 50 raw_shrimp)
2. Create a tab called "Raw Fish"
3. Stay on Main tab
4. Click and hold on the raw_shrimp item
5. Verify drag preview appears (item icon + name)
6. Drag the preview over the "Raw Fish" tab button
7. Release mouse button
8. Verify Main tab no longer has raw_shrimp
9. Click "Raw Fish" tab
10. Verify raw_shrimp (50) is now in this tab

**Expected Results:**
- Drag preview follows mouse cursor smoothly
- Items move completely from source to destination tab
- Item counts are preserved
- UI updates correctly

### 4. Rename Tab
**Steps:**
1. Create a new tab (should be "Tab 1" or similar)
2. Right-click on the tab button
3. Verify context menu appears with "Rename" and "Delete"
4. Click "Rename"
5. Verify dialog appears asking for new name
6. Enter "My Awesome Tab" (19 characters)
7. Click OK
8. Verify tab name updates

**Edge Cases to Test:**
- Enter empty string → should reject/keep old name
- Enter very long name (>20 chars) → should truncate to 20
- Enter normal name → should work

**Expected Results:**
- Context menu appears on right-click
- Dialog validates input properly
- Tab name updates immediately

### 5. Delete Tab
**Steps:**
1. Create a tab and add some items to it (e.g., 10 cooked_shrimp)
2. Note the item count
3. Right-click the tab
4. Select "Delete"
5. Verify tab disappears
6. Switch to Main tab
7. Verify the items from deleted tab are now in Main tab (10 cooked_shrimp)

**Expected Results:**
- Tab is removed from tab bar
- Items are preserved in Main tab
- No data loss

### 6. Main Tab Protection
**Steps:**
1. Right-click on "Main" tab
2. Verify NO context menu appears (or menu is disabled)
3. Try to delete Main tab through any means

**Expected Results:**
- Main tab cannot be renamed or deleted
- Main tab always remains visible

### 7. Maximum Tabs Limit
**Steps:**
1. Create tabs until you can't create more
2. Count total tabs (should be max 10)
3. Try to click "+" button
4. Verify no new tab is created
5. Check console for error message

**Expected Results:**
- Maximum 10 tabs enforced
- Error message in console: "Cannot create more than 10 tabs"
- UI remains stable

### 8. Save and Load Persistence
**Steps:**
1. Create 2-3 custom tabs with different names
2. Distribute items across tabs
3. Note current state (tab names, item counts per tab)
4. Click "Change Character" button
5. Select the same character again
6. Navigate to Inventory
7. Verify all tabs exist with correct names
8. Verify items are in correct tabs with correct counts

**Expected Results:**
- All tabs restored correctly
- Item distribution preserved
- No data loss after save/load

### 9. Drag Preview Visual Feedback
**Steps:**
1. Have items in Main tab
2. Click and hold on an item
3. Move mouse around the screen
4. Observe drag preview behavior

**Expected Results:**
- Preview appears immediately on click
- Preview follows mouse cursor smoothly
- Preview shows item icon and name
- Preview disappears on release
- Preview visible above all UI elements (high z-index)

### 10. Tab Switching During Gameplay
**Steps:**
1. Start training a skill that produces items
2. Switch between different tabs while training
3. Verify items still accumulate in the correct tab

**Expected Results:**
- Items go to whichever tab is currently selected
- Switching tabs doesn't interrupt training
- Item notifications (toasts) still appear

## Performance Testing

### Large Inventory Test
1. Use debug commands or extended play to accumulate 100+ unique items
2. Distribute across multiple tabs
3. Switch between tabs rapidly
4. Drag items between tabs
5. Verify no lag or stuttering

**Expected Results:**
- Smooth performance with large item counts
- No memory leaks
- UI remains responsive

## Visual Inspection Checklist

### Tab Bar
- [ ] Tabs align horizontally
- [ ] Scrollbar appears if many tabs
- [ ] Selected tab is visually distinct
- [ ] "+" button is clearly visible

### Drag Preview
- [ ] Preview is semi-transparent or distinct from regular items
- [ ] Icon renders correctly
- [ ] Text is readable
- [ ] Preview doesn't interfere with other UI

### Context Menu
- [ ] Menu appears near cursor
- [ ] Text is readable
- [ ] Options are correctly labeled

### Dialogs
- [ ] Rename dialog is centered
- [ ] Text input is clearly visible
- [ ] Buttons are functional

## Error Handling Tests

### Invalid Operations
1. Try to move items that don't exist
2. Try to access deleted tabs
3. Try rapid tab creation/deletion
4. Try drag-drop to invalid targets

**Expected Results:**
- No crashes
- Graceful error handling
- Console errors are descriptive

## Browser Testing (Web Export)

If testing web build:
1. Test on Chrome, Firefox, Safari
2. Verify touch support on mobile devices
3. Test drag and drop with touch
4. Verify save/load works in browser storage

## Reporting Issues

If any test fails, document:
- Steps to reproduce
- Expected vs actual behavior
- Console errors
- Screenshots/video if possible

## Sign-Off

After completing all tests:
- [ ] All basic functionality works
- [ ] No crashes or errors
- [ ] Performance is acceptable
- [ ] Visual quality is good
- [ ] Save/load works correctly

**Tester Name:** _______________
**Date:** _______________
**Build Version:** _______________
**Platform:** _______________
