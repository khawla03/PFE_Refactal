extends Level


onready var computer = $Computer


func _ready():
	computer.set_highlight(true)
	DialogicUtils.start_dialog(self, "final0", "_on_dialog_finished")


func _on_dialog_finished(arg):
	if arg == "end":
		if not Vars.get_var("submitted_score"):
			Vars.show_submit_screen = true
		return_to_menu()
	else:
		PlayerUtils.set_player_focus(get_tree(), false)

func _on_Computer_started_coding(player):
	$CentralSystem.show()
	PlayerUtils.set_player_focus(get_tree(), true)


func _on_CentralSystem_connected():
	DialogicUtils.start_dialog(self, "final1", "_on_dialog_finished")
