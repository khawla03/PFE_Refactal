extends Level


onready var button = find_node("Button") as ButtonItem
onready var computer = find_node("PC") as Computer
onready var door = find_node("Door") as DoorItem


func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_Slider_hidden():
	DialogicUtils.start_dialog(self, "Tuto1_0", "_on_dialog_signal")
	computer.is_interactable = false


func _on_Button_pressed():
	DialogicUtils.start_dialog(self, "Tuto1_1", "_on_dialog_signal")
	button.connect("pressed", self, "_on_Button_pressed_again")
	button.set_highlight(false)
	computer.is_interactable = true


func _on_Button_pressed_again():
	$ButtonLoopTimer.start()


func _on_dialog_signal(arg):
	if arg == "after_slide":
		PlayerUtils.set_player_focus(get_tree(), false)
		button.set_highlight(true)
	elif arg == "after_click":
		PlayerUtils.set_player_focus(get_tree(), false)
		computer.set_highlight(true)
	else:
		PlayerUtils.set_player_focus(get_tree(), false)

func _on_PC_started_coding(player):
	DialogicUtils.start_dialog(self, "Tuto1_2")
	computer.connect("started_coding", self, "_on_PC_started_coding_again")


func _on_PC_started_coding_again(player):
	DialogicUtils.start_dialog(self, "Tuto1_computer_loop")


func _on_Door_opened():
	computer.set_highlight(false)
	computer.is_interactable = false
	button.disconnect("pressed", self, "_on_Button_pressed_again")
	computer.disconnect("started_coding", self, "_on_PC_started_coding_again")


func _on_ButtonLoopTimer_timeout():
	if not door.is_open:
		var dialog = DialogicUtils.start_dialog(self, "Tuto1_button_loop")
		dialog.connect("dialogic_signal", self, "_on_dialog_signal")
