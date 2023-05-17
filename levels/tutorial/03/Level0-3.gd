extends Level


onready var computer = find_node("Computer") as Computer


func _on_DoorSingle_interact(door, player):
	computer.is_interactable = false
	end_level(player)


func _on_Computer_started_coding(player):
	DialogicUtils.start_dialog(self, "Tuto3_0")
	computer.connect("started_coding", self, "_on_started_coding_again")


func _on_started_coding_again(player):
	DialogicUtils.start_dialog(self, "Tuto3_loop")


func _on_Door_opened():
	computer.is_interactable = false
