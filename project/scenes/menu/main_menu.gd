extends Node

@onready var title_label: Label = %TitleLabel
@onready var version_label: Label = %VersionLabel

@onready var start_game_button: Button = %StartGameButton
@onready var options_button: Button = %OptionsButton
@onready var credits_button: Button = %CreditsButton


func _ready() -> void:
	title_label.text = ProjectSettings.get_setting("application/config/name")
	version_label.text = ProjectSettings.get_setting("application/config/version")
