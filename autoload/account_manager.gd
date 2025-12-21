## AccountManager Autoload
## Handles user account management (login, registration, authentication)
extends Node

const ACCOUNTS_FILE := "user://idlescapers_accounts.json"

signal account_created(username: String)
signal logged_in(username: String)
signal logged_out()

## Account data structure
## {
##   "username": String,
##   "password_hash": String,  # Hashed password for basic security
##   "created_at": int (unix timestamp),
##   "character_slots": Array[int]  # List of character slot indices owned by this account
## }
var accounts: Dictionary = {}  # username: account_data

## Currently logged in username (empty string means no one is logged in)
var current_username: String = ""

## Simple salt for password hashing (in a real production app, use per-user salts)
const PASSWORD_SALT := "idlescapers_2024_salt"

func _ready() -> void:
	load_accounts()

## Hash a password with salt for storage
func _hash_password(password: String) -> String:
	return (password + PASSWORD_SALT).sha256_text()

## Load accounts from file
func load_accounts() -> void:
	if not FileAccess.file_exists(ACCOUNTS_FILE):
		print("[AccountManager] No accounts file found, starting fresh.")
		accounts.clear()
		return
	
	var file := FileAccess.open(ACCOUNTS_FILE, FileAccess.READ)
	if not file:
		print("[AccountManager] Failed to open accounts file.")
		return
	
	var json_string := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var error := json.parse(json_string)
	if error != OK:
		print("[AccountManager] Failed to parse accounts file: ", json.get_error_message())
		return
	
	accounts = json.data
	print("[AccountManager] Loaded %d accounts." % accounts.size())

## Save accounts to file
func save_accounts() -> void:
	var file := FileAccess.open(ACCOUNTS_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(accounts, "\t"))
		file.close()
		print("[AccountManager] Accounts saved.")

## Create a new account
func create_account(username: String, password: String) -> bool:
	var clean_username := username.strip_edges()
	
	if clean_username.is_empty():
		print("[AccountManager] Username cannot be empty.")
		return false
	
	if password.is_empty():
		print("[AccountManager] Password cannot be empty.")
		return false
	
	if clean_username.length() < 3:
		print("[AccountManager] Username must be at least 3 characters.")
		return false
	
	if password.length() < 6:
		print("[AccountManager] Password must be at least 6 characters.")
		return false
	
	if accounts.has(clean_username):
		print("[AccountManager] Username already exists: %s" % clean_username)
		return false
	
	var now := int(Time.get_unix_time_from_system())
	var password_hash := _hash_password(password)
	
	var account_data := {
		"username": clean_username,
		"password_hash": password_hash,
		"created_at": now,
		"character_slots": []
	}
	
	accounts[clean_username] = account_data
	save_accounts()
	account_created.emit(clean_username)
	print("[AccountManager] Created account: %s" % clean_username)
	return true

## Login to an existing account
func login(username: String, password: String) -> bool:
	var clean_username := username.strip_edges()
	
	if not accounts.has(clean_username):
		print("[AccountManager] Account not found: %s" % clean_username)
		return false
	
	var account_data: Dictionary = accounts[clean_username]
	var password_hash := _hash_password(password)
	
	if account_data["password_hash"] != password_hash:
		print("[AccountManager] Invalid password for: %s" % clean_username)
		return false
	
	current_username = clean_username
	logged_in.emit(clean_username)
	print("[AccountManager] Logged in: %s" % clean_username)
	return true

## Logout from current account
func logout() -> void:
	if current_username.is_empty():
		print("[AccountManager] No one is logged in.")
		return
	
	print("[AccountManager] Logged out: %s" % current_username)
	current_username = ""
	logged_out.emit()

## Check if a user is currently logged in
func is_logged_in() -> bool:
	return not current_username.is_empty()

## Get current account data
func get_current_account() -> Dictionary:
	if current_username.is_empty():
		return {}
	return accounts.get(current_username, {})

## Add a character slot to current account
func add_character_slot(slot: int) -> void:
	if current_username.is_empty():
		print("[AccountManager] No one is logged in.")
		return
	
	var account_data: Dictionary = accounts[current_username]
	var slots: Array = account_data.get("character_slots", [])
	
	if not slots.has(slot):
		slots.append(slot)
		account_data["character_slots"] = slots
		save_accounts()
		print("[AccountManager] Added slot %d to account: %s" % [slot, current_username])

## Remove a character slot from current account
func remove_character_slot(slot: int) -> void:
	if current_username.is_empty():
		print("[AccountManager] No one is logged in.")
		return
	
	var account_data: Dictionary = accounts[current_username]
	var slots: Array = account_data.get("character_slots", [])
	
	var index := slots.find(slot)
	if index >= 0:
		slots.remove_at(index)
		account_data["character_slots"] = slots
		save_accounts()
		print("[AccountManager] Removed slot %d from account: %s" % [slot, current_username])

## Get character slots for current account
func get_character_slots() -> Array:
	if current_username.is_empty():
		return []
	
	var account_data: Dictionary = accounts.get(current_username, {})
	return account_data.get("character_slots", [])

## Check if account exists
func account_exists(username: String) -> bool:
	return accounts.has(username.strip_edges())
