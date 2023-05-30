extends Level


onready var door = $Door
onready var button = $Button
onready var speechTrigger = find_node("SpeechTrigger") as Area


func _ready():
	DialogicUtils.start_dialog(self, "ControlsTuto", "_on_dialog_finished")
	PlayerUtils.get_player(get_tree()).connect("look_at_item", self, "_on_player_look_at_item")


func _on_Button_pressed():
	door.open()


func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_dialog_finished(arg):
	if arg == "dialog_end":
		get_node(slider).show()
	if arg == "dialog1_end":
		PlayerUtils.set_player_focus(get_tree(), false)


func _on_SpeechTrigger_body_entered(body):
	if body.is_in_group("Player"):
		speechTrigger.queue_free()
		DialogicUtils.start_dialog(self, "ControlsTuto1", "_on_dialog_finished")


func _on_player_look_at_item(item_name: String):
	if item_name == "Exit Door":
		DialogicUtils.start_dialog(self, "Tuto_fin", "_on_dialogic_signal")
		PlayerUtils.get_player(get_tree()).disconnect("look_at_item", self, "_on_player_look_at_item")


