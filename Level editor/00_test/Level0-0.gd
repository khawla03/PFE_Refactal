extends Level


onready var button = find_node("Button") as ButtonItem
onready var computer = find_node("PC") as Computer
onready var door = find_node("Door") as DoorItem


func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_Slider_hidden():
	PlayerUtils.set_player_focus(get_tree(), false)



#func _on_dialog_signal(arg):
#	if arg == "after_slide":
#		PlayerUtils.set_player_focus(get_tree(), false)
#		button.set_highlight(true)
#	elif arg == "after_click":
#		PlayerUtils.set_player_focus(get_tree(), false)
#		computer.set_highlight(true)
#	else:
#		PlayerUtils.set_player_focus(get_tree(), false)



func _on_Door_opened():
	computer.set_highlight(false)
	computer.is_interactable = false
	#button.disconnect("pressed", self, "_on_Button_pressed_again")
	computer.disconnect("started_coding", self, "_on_PC_started_coding_again")

