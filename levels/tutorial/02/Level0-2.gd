extends Level


onready var door = $Door
onready var screen = $PasswordScreen
onready var computer = find_node("Computer") as Computer


func _ready():
	screen.set_value(StringUtils.get_random_string(4))
	DialogicUtils.start_dialog(self, "Tuto4_0", "_on_dialogic_signal")


func _on_dialogic_signal(arg):
	PlayerUtils.set_player_focus(get_tree(), false)


func _on_PasswordScreen_value_changed(new_val):
	door.set_password(new_val)


func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_PasswordChanger_timeout():
	screen.set_value(StringUtils.get_random_string(4))


func _on_Door_opened():
	computer.is_interactable = false
