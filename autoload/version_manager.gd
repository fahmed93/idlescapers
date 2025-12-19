## VersionManager Autoload
## Manages game version information
extends Node

const VERSION_FILE_PATH := "res://version.txt"

# Version stored as String to preserve formatting and simplify display
# The actual increment happens in GitHub Actions workflow
var version: String = "0"

func _ready() -> void:
	_load_version()

## Load version from file
func _load_version() -> void:
	if FileAccess.file_exists(VERSION_FILE_PATH):
		var file := FileAccess.open(VERSION_FILE_PATH, FileAccess.READ)
		if file:
			version = file.get_as_text().strip_edges()
			file.close()
			print("[VersionManager] Loaded version: %s" % version)
		else:
			push_warning("[VersionManager] Failed to open version file")
			version = "0"
	else:
		push_warning("[VersionManager] Version file not found, using default: 0")
		version = "0"

## Get version string formatted for display
func get_version_string() -> String:
	return "v%s" % version
