extends VBoxContainer
class_name Forum

@onready var username_label: Label = %UsernameLabel
@onready var username_input: LineEdit = %UsernameInput
@onready var password_label: Label = %PasswordLabel
@onready var password_input: LineEdit = %PasswordInput

func _ready() -> void:
	username_label.text = i18n.ui(username_label.text)
	password_label.text = i18n.ui(password_label.text)
