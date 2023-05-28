extends Level

onready var MsgScreen = $MessagesScreen as MessageScreenItem
onready var valueScreen = $ScreenItem as ScreenItem
onready var door = $Door as DoorItem
onready var checkerTimer = $CheckTimer
onready var computer = find_node("Computer") as Computer
onready var doorsingle = find_node("DoorSingle2") as DoorItem
onready var doorsingle0 = find_node("DoorSingle") as DoorItem


# Called when the node enters the scene tree for the first time.
func _ready():
	valueScreen.set_value("Room12")
	checkerTimer.start()
	pass # Replace with function body.
	




func _on_CheckTimer_timeout():
	if not MsgScreen.is_on and not valueScreen.is_on:
		door.open()
	pass # Replace with function body.




func _on_DoorSingle2_interact(doorsingle, player):
	end_level(player)



func _on_Door_opened():
	computer.is_interactable = false
	checkerTimer.stop()
	DialogicUtils.start_dialog(self, "Facade_2", "_on_dialogic_signal")
	pass # Replace with function body.


func _on_item_pressed(item_name):
	if item_name == "Main":
		DialogicUtils.start_dialog(self, "Expert_1")
		codingGUI.disconnect("item_pressed", self, "_on_item_pressed")
