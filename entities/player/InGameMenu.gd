extends CanvasLayer


signal resume()

const ConfirmDialog = preload("res://entities/dialogs/ConfirmDialog.tscn")

var visible := false

onready var anim = $AnimationPlayer
onready var menu = $Menu
onready var resumeButton = $Menu/HBoxContainer/MenuOptions/ResumeButton
onready var restartButton = $Menu/HBoxContainer/MenuOptions/RestartButton
onready var settingsButton = $Menu/HBoxContainer/MenuOptions/SettingsButton
onready var returnButton = $Menu/HBoxContainer/MenuOptions/ReturnButton
onready var quitButton = $Menu/HBoxContainer/MenuOptions/QuitButton



func _ready():
	if OS.get_name() == "HTML5":
		quitButton.hide()


func show():
	anim.play("show")
	visible = true


func hide():
	menu.hide()
	visible = false


func _on_QuitButton_pressed():
	Dialog.show_confirm_dialog(
		"Quit the game?",
		funcref(get_tree(), "quit"),
		menu
	)
	ActionsData.save_action('Level quitted','Game quitted')


func _on_ResumeButton_pressed():
	hide()
	emit_signal("resume")


func _on_ReturnButton_pressed():
	Dialog.show_confirm_dialog(
		"Return to the main menu?",
		funcref(get_tree().get_nodes_in_group("Level")[0], "return_to_menu"),
		menu,
		true
	)
	ActionsData.save_action('Level quitted','Returned to main menu')


func _on_RestartButton_pressed():
	Dialog.show_confirm_dialog(
		"Restart the level?",
		funcref(get_tree().get_nodes_in_group("Level")[0], "restart"),
		menu,
		true
	)


func _on_SettingsButton_button_up():
	Settings.show()
