## Login screen controller
## Handles user login and account creation via Firebase
extends Control

const STARTUP_SCENE := "res://scenes/startup.tscn"

@onready var login_panel: PanelContainer = $CenterContainer/LoginPanel
@onready var create_panel: PanelContainer = $CenterContainer/CreatePanel

# Login form
@onready var login_username: LineEdit = $CenterContainer/LoginPanel/VBoxContainer/UsernameInput
@onready var login_password: LineEdit = $CenterContainer/LoginPanel/VBoxContainer/PasswordInput
@onready var login_button: Button = $CenterContainer/LoginPanel/VBoxContainer/LoginButton
@onready var login_error: Label = $CenterContainer/LoginPanel/VBoxContainer/ErrorLabel
@onready var show_create_button: Button = $CenterContainer/LoginPanel/VBoxContainer/ShowCreateButton

# Create account form
@onready var create_username: LineEdit = $CenterContainer/CreatePanel/VBoxContainer/UsernameInput
@onready var create_password: LineEdit = $CenterContainer/CreatePanel/VBoxContainer/PasswordInput
@onready var create_password_confirm: LineEdit = $CenterContainer/CreatePanel/VBoxContainer/PasswordConfirmInput
@onready var create_button: Button = $CenterContainer/CreatePanel/VBoxContainer/CreateButton
@onready var create_error: Label = $CenterContainer/CreatePanel/VBoxContainer/ErrorLabel
@onready var show_login_button: Button = $CenterContainer/CreatePanel/VBoxContainer/ShowLoginButton

var is_processing: bool = false

func _ready() -> void:
	# Show login panel by default
	login_panel.visible = true
	create_panel.visible = false
	
	# Connect button signals
	login_button.pressed.connect(_on_login_pressed)
	show_create_button.pressed.connect(_on_show_create_pressed)
	create_button.pressed.connect(_on_create_pressed)
	show_login_button.pressed.connect(_on_show_login_pressed)
	
	# Connect enter key for login
	login_password.text_submitted.connect(_on_login_text_submitted)
	create_password_confirm.text_submitted.connect(_on_create_text_submitted)
	
	# Clear error labels
	login_error.text = ""
	create_error.text = ""
	
	# Set password fields to secret mode
	login_password.secret = true
	create_password.secret = true
	create_password_confirm.secret = true
	
	# Connect to AccountManager signals for async Firebase responses
	AccountManager.logged_in.connect(_on_logged_in)
	AccountManager.account_created.connect(_on_account_created)
	AccountManager.auth_error.connect(_on_auth_error)

func _on_login_pressed() -> void:
	if is_processing:
		return
	
	login_error.text = ""
	
	var email := login_username.text.strip_edges()
	var password := login_password.text
	
	if email.is_empty():
		login_error.text = "Email cannot be empty"
		return
	
	if password.is_empty():
		login_error.text = "Password cannot be empty"
		return
	
	# Start Firebase login (async)
	is_processing = true
	login_button.disabled = true
	login_error.text = "Logging in..."
	AccountManager.login(email, password)

func _on_login_text_submitted(_text: String) -> void:
	_on_login_pressed()

func _on_show_create_pressed() -> void:
	login_panel.visible = false
	create_panel.visible = true
	create_username.grab_focus()
	create_error.text = ""

func _on_create_pressed() -> void:
	if is_processing:
		return
	
	create_error.text = ""
	
	var email := create_username.text.strip_edges()
	var password := create_password.text
	var password_confirm := create_password_confirm.text
	
	if email.is_empty():
		create_error.text = "Email cannot be empty"
		return
	
	# Basic email validation
	if not "@" in email or not "." in email:
		create_error.text = "Please enter a valid email address"
		return
	
	if password.is_empty():
		create_error.text = "Password cannot be empty"
		return
	
	if password.length() < 6:
		create_error.text = "Password must be at least 6 characters"
		return
	
	if password != password_confirm:
		create_error.text = "Passwords do not match"
		return
	
	# Start Firebase account creation (async)
	is_processing = true
	create_button.disabled = true
	create_error.text = "Creating account..."
	AccountManager.create_account(email, password)

func _on_create_text_submitted(_text: String) -> void:
	_on_create_pressed()

func _on_show_login_pressed() -> void:
	create_panel.visible = false
	login_panel.visible = true
	login_username.grab_focus()
	login_error.text = ""

## Called when AccountManager successfully logs in
func _on_logged_in(email: String) -> void:
	print("[Login] Successfully logged in: %s" % email)
	is_processing = false
	# Successfully logged in, go to character selection
	get_tree().change_scene_to_file(STARTUP_SCENE)

## Called when AccountManager successfully creates account
func _on_account_created(email: String) -> void:
	print("[Login] Account created: %s" % email)
	is_processing = false
	# Account created, Firebase auto-logs in, so go to character selection
	get_tree().change_scene_to_file(STARTUP_SCENE)

## Called when AccountManager encounters an auth error
func _on_auth_error(error_message: String) -> void:
	print("[Login] Auth error: %s" % error_message)
	is_processing = false
	login_button.disabled = false
	create_button.disabled = false
	
	# Show error in appropriate panel
	if login_panel.visible:
		login_error.text = error_message
	elif create_panel.visible:
		create_error.text = error_message
