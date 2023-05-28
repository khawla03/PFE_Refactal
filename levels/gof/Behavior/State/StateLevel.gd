extends Level

onready var door = find_node("Door") as DoorItem
onready var computer = find_node("Computer") as Computer
onready var oxBottles = find_node("ox bottles") as OxBottlesItem
onready var timer=$CheckTimer
onready var timer2=$Timer
onready var door2 = find_node("DoorSingle2") as DoorItem



# Called when the node enters the scene tree for the first time.
func _ready():
	codingGUI.connect("item_pressed", self, "_on_item_pressed")
	oxBottles.empty()
	timer.start()
	pass # Replace with function body.


func _on_ox_bottles_interact(oxBottles,player):
	if oxBottles.is_full:
		door.open()



func _on_CheckTimer_timeout():
	
	if oxBottles.is_full:
		door.open()
	pass # Replace with function body.


func _on_DoorSingle2_interact(door2, player):
	end_level(player)



func _on_Slider_hidden():
	timer2.start()
	
	
	pass # Replace with function body.

func _on_dialogic_signal(Bonus):
	PlayerUtils.set_player_focus(get_tree(), false)
	bonus = DialogicClass.get_variable("Bonus")
	print(bonus)


func _on_Timer_timeout():
	DialogicUtils.start_dialog(self, "State_0", "_on_dialogic_signal")
	pass # Replace with function body.


func _on_item_pressed(item_name):
	if item_name == "OxBottles":
		DialogicUtils.start_dialog(self, "State_1")
		codingGUI.disconnect("item_pressed", self, "_on_item_pressed")


func _on_HintTimer_timeout():
	DialogicUtils.start_dialog(self, "Hints", "_on_dialogic_signal")
	pass # Replace with function body.

func _on_Door_opened():
	computer.is_interactable = false
	DialogicUtils.start_dialog(self, "State_2", "_on_dialogic_signal")
	timer.stop()
