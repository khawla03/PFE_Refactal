extends Level


onready var door = $Door
onready var screen = $PasswordScreen
onready var computer = find_node("Computer") as Computer


func _ready():
	screen.set_value(StringUtils.get_random_string(4))


func _on_PasswordScreen_value_changed(new_val):
	door.set_password(new_val)


func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_Slider_hidden():
	DialogicUtils.start_dialog(self, "Tuto2_1", "_on_dialogic_signal")
	$DiscoverTimer.start()


func _on_dialogic_signal(arg):
	PlayerUtils.set_player_focus(get_tree(), false)
	if arg == "discover":
		PlayerUtils.set_discover_mode(get_tree(), false)


func _on_DiscoverTimer_timeout():
	PlayerUtils.set_discover_mode(get_tree(), true)


func _on_DialogTrigger_body_entered(body):
	if body.is_in_group("Player"):
		$DialogTrigger.disconnect("body_entered", self, "_on_DialogTrigger_body_entered")
		DialogicUtils.start_dialog(self, "Tuto2_2", "_on_dialogic_signal")


func _on_Door_opened():
	computer.is_interactable = false
