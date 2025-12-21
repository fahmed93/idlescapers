## Login screen controller
## Handles user login and account creation
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
@ontml:parameter name="create_error: Label = $CenterContainer/CreatePanel/VBoxContainer/ErrorLabel
@onready var show_login_button: Button = $CenterContainer/CreatePanel/VBoxContainer/ShowLoginButton

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

func _on_login_pressed() -> void:
	login_error.text = ""
	
	var username := login_username.text.strip_edges()
	var password := login_password.text
	
	if username.is_empty():
		login_error.text = "Username cannot be empty"
		return
	
	if password.is_empty():
		login_error.text = "Password cannot be empty"
		return
	
	if AccountManager.login(username, password):
		# Successfully logged in, go to character selection
		get_tree().change_scene_to_file(STARTUP_SCENE)
	else:
		login_error.text = "Invalid username or password"

func _on_login_text_submitted(_text: String) -> void:
	_on_login_pressed()

func _on_show_create_pressed() -> void:
	login_panel.visible = false
	create_panel.visible = true
	create_username.grab_focus()
	create_error.text = ""

func _on_create_pressed() -> void:
	create_error.text = ""
	
	var username := create_username.text.strip_edges()
	var password := create_password.text
	var password_confirm := create_password_confirm.text
	
	if username.is_empty():
		create_error.text = "Username cannot be empty"
		return
	
	if username.length() < 3:
		create_error.text = "Username must be at least 3 characters"
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
	
	if AccountManager.create_account(username, password):
		# Account created successfully, now login automatically
		if AccountManager.login(username, password):
			get_tree().change_scene_to_file(STARTUP_SCENE)
	else:
		create_error.text = "Username already exists"

func _on_create_text_submitted(_text: String) -> void:
	_on_create_pressed()

func _on_show_login_pressed() -> void:
	create_panel.visible = false
	login_panel.visible = true
	login_username.grab_focus()
	login_error.text = ""
