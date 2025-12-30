## AccountManager Autoload
## Handles user account management via Firebase Authentication
extends Node

const CHARACTER_SLOTS_FILE := "user://skillforge_character_slots.json"

signal account_created(email: String)
signal logged_in(email: String)
signal logged_out()
signal auth_error(error_message: String)

## Character slots data structure
## {
##   "user_id": {
##     "character_slots": Array[int]  # List of character slot indices owned by this user
##   }
## }
var character_slots_data: Dictionary = {}

## Currently logged in user email (empty string means no one is logged in)
var current_username: String = ""

## Current Firebase user ID
var current_user_id: String = ""

## Firebase authentication state
var firebase_auth = null

func _ready() -> void:
	# Wait for Firebase to be ready
	await get_tree().process_frame
	
	if Firebase and Firebase.Auth:
		firebase_auth = Firebase.Auth
		
		# Connect to Firebase auth signals
		firebase_auth.signup_succeeded.connect(_on_signup_succeeded)
		firebase_auth.signup_failed.connect(_on_signup_failed)
		firebase_auth.login_succeeded.connect(_on_login_succeeded)
		firebase_auth.login_failed.connect(_on_login_failed)
		firebase_auth.logout_succeeded.connect(_on_logout_succeeded)
		
		print("[AccountManager] Firebase authentication initialized.")
	else:
		print("[AccountManager] ERROR: Firebase not available! Check plugin configuration.")
	
	load_character_slots()

## Load character slots from file
func load_character_slots() -> void:
	if not FileAccess.file_exists(CHARACTER_SLOTS_FILE):
		print("[AccountManager] No character slots file found, starting fresh.")
		character_slots_data.clear()
		return
	
	var file := FileAccess.open(CHARACTER_SLOTS_FILE, FileAccess.READ)
	if not file:
		print("[AccountManager] Failed to open character slots file.")
		return
	
	var json_string := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var error := json.parse(json_string)
	if error != OK:
		print("[AccountManager] Failed to parse character slots file: ", json.get_error_message())
		return
	
	character_slots_data = json.data
	print("[AccountManager] Loaded character slots data.")

## Save character slots to file
func save_character_slots() -> void:
	var file := FileAccess.open(CHARACTER_SLOTS_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(character_slots_data, "\t"))
		file.close()
		print("[AccountManager] Character slots saved.")

## Create a new account using Firebase
func create_account(email: String, password: String) -> void:
	var clean_email := email.strip_edges()
	
	if clean_email.is_empty():
		auth_error.emit("Email cannot be empty")
		print("[AccountManager] Email cannot be empty.")
		return
	
	if password.is_empty():
		auth_error.emit("Password cannot be empty")
		print("[AccountManager] Password cannot be empty.")
		return
	
	if password.length() < 6:
		auth_error.emit("Password must be at least 6 characters")
		print("[AccountManager] Password must be at least 6 characters.")
		return
	
	if not firebase_auth:
		auth_error.emit("Firebase authentication not available")
		print("[AccountManager] Firebase authentication not available.")
		return
	
	# Use Firebase signup
	firebase_auth.signup_with_email_and_password(clean_email, password)
	print("[AccountManager] Creating account for: %s" % clean_email)

## Login to an existing account using Firebase
func login(email: String, password: String) -> void:
	var clean_email := email.strip_edges()
	
	if not firebase_auth:
		auth_error.emit("Firebase authentication not available")
		print("[AccountManager] Firebase authentication not available.")
		return
	
	# Use Firebase login
	firebase_auth.login_with_email_and_password(clean_email, password)
	print("[AccountManager] Attempting login for: %s" % clean_email)

## Logout from current account
func logout() -> void:
	if not firebase_auth:
		print("[AccountManager] Firebase authentication not available.")
		return
	
	if current_username.is_empty():
		print("[AccountManager] No one is logged in.")
		return
	
	firebase_auth.logout()
	print("[AccountManager] Logging out: %s" % current_username)

## Check if a user is currently logged in
func is_logged_in() -> bool:
	return not current_username.is_empty() and not current_user_id.is_empty()

## Get current account data
func get_current_account() -> Dictionary:
	if current_user_id.is_empty():
		return {}
	return character_slots_data.get(current_user_id, {})

## Add a character slot to current account
func add_character_slot(slot: int) -> void:
	if current_user_id.is_empty():
		print("[AccountManager] No one is logged in.")
		return
	
	if not character_slots_data.has(current_user_id):
		character_slots_data[current_user_id] = {"character_slots": []}
	
	var user_data: Dictionary = character_slots_data[current_user_id]
	var slots: Array = user_data.get("character_slots", [])
	
	if not slots.has(slot):
		slots.append(slot)
		user_data["character_slots"] = slots
		save_character_slots()
		print("[AccountManager] Added slot %d to user: %s" % [slot, current_username])

## Remove a character slot from current account
func remove_character_slot(slot: int) -> void:
	if current_user_id.is_empty():
		print("[AccountManager] No one is logged in.")
		return
	
	if not character_slots_data.has(current_user_id):
		return
	
	var user_data: Dictionary = character_slots_data[current_user_id]
	var slots: Array = user_data.get("character_slots", [])
	
	var index := slots.find(slot)
	if index >= 0:
		slots.remove_at(index)
		user_data["character_slots"] = slots
		save_character_slots()
		print("[AccountManager] Removed slot %d from user: %s" % [slot, current_username])

## Get character slots for current account
func get_character_slots() -> Array:
	if current_user_id.is_empty():
		return []
	
	if not character_slots_data.has(current_user_id):
		return []
	
	var user_data: Dictionary = character_slots_data.get(current_user_id, {})
	return user_data.get("character_slots", [])

## Check if account exists (not applicable with Firebase, always returns false)
func account_exists(email: String) -> bool:
	# With Firebase, we can't check if an account exists without authentication
	return false

## Firebase callback: signup succeeded
func _on_signup_succeeded(auth_info: Dictionary) -> void:
	print("[AccountManager] Signup succeeded: ", auth_info)
	current_username = auth_info.get("email", "")
	current_user_id = auth_info.get("localid", "")
	
	# Initialize character slots for new user
	if not character_slots_data.has(current_user_id):
		character_slots_data[current_user_id] = {"character_slots": []}
		save_character_slots()
	
	account_created.emit(current_username)
	logged_in.emit(current_username)

## Firebase callback: signup failed
func _on_signup_failed(error_code: int, error_message: String) -> void:
	print("[AccountManager] Signup failed: [%d] %s" % [error_code, error_message])
	auth_error.emit(error_message)

## Firebase callback: login succeeded
func _on_login_succeeded(auth_info: Dictionary) -> void:
	print("[AccountManager] Login succeeded: ", auth_info)
	current_username = auth_info.get("email", "")
	current_user_id = auth_info.get("localid", "")
	
	# Initialize character slots if not exists
	if not character_slots_data.has(current_user_id):
		character_slots_data[current_user_id] = {"character_slots": []}
		save_character_slots()
	
	logged_in.emit(current_username)

## Firebase callback: login failed
func _on_login_failed(error_code: int, error_message: String) -> void:
	print("[AccountManager] Login failed: [%d] %s" % [error_code, error_message])
	auth_error.emit(error_message)

## Firebase callback: logout succeeded
func _on_logout_succeeded() -> void:
	print("[AccountManager] Logout succeeded")
	current_username = ""
	current_user_id = ""
	logged_out.emit()
