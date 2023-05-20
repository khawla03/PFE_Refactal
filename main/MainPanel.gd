extends MenuPanel


signal level_button_toggled(pressed)
signal new_game()
signal continue_game()
signal leaderboard()
signal leveleditor()

onready var levelButton = find_node("LevelsButton") as Button
onready var continueButton = find_node("ContinueButton") as Button
onready var exitButton = find_node("ExitButton") as Button
onready var versionLabel = find_node("Version") as Label


func _ready():
	init_buttons()
	Settings.connect("reset_progress", self, "init_buttons")
	versionLabel.text = Vars.GAME_VERSION


func init_buttons():
	if OS.get_name() == "HTML5":
		exitButton.hide()
	levelButton.disabled = Progress.is_all_levels_locked()
	continueButton.disabled = Progress.is_all_levels_locked()


func _on_LevelsButton_pressed():
	sound.play_sound(SoundPlayer.SWITCH)
	emit_signal("level_button_toggled", levelButton.pressed)


func _on_ExitButton_pressed():
	Dialog.show_confirm_dialog(
		"Quit the game?",
		funcref(get_tree(), "quit"),
		get_parent().get_parent()
	)


func _on_SettingsButton_button_up():
	Settings.show()


func _on_NewGameButton_button_up():
	emit_signal("new_game")


func _on_ContinueButton_button_up():
	emit_signal("continue_game")


func hide():
	.hide()
	levelButton.pressed = false


func _on_LeaderBoard_button_up():
	emit_signal("leaderboard")



func _on_levelEditor_pressed():
	emit_signal("leveleditor")

	pass # Replace with function body.
