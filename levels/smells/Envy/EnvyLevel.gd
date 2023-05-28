extends Level

onready var message = $MessagesScreen
onready var button = $Button
onready var door = $Door
onready var computer = $Computer


func _on_DoorSingle2_interact(door, player):
	end_level(player)
	pass # Replace with function body.


func _on_CheckTimer_timeout():
	if message.code.has_method("writeAndSendMessage"):
		button.connect_pressed=true
	pass # Replace with function body.

var nbPress = 0
func _on_Button_pressed():
	if button.connect_pressed==true:
		message.send_message()
		door.open()
	nbPress=nbPress+1
	ActionsData.save_action('Button Pressed',"number of tests :" + str(nbPress))
	if nbPress > 4:
		if door.is_open == false:
			DialogicUtils.start_dialog(self, "Hints", "_on_dialogic_signal")
			button.disconnect("pressed",self,"_on_Button_pressed")


func _on_Door_opened():
	button.disconnect("pressed",self,"_on_Button_pressed")
	computer.is_interactable = false
	pass # Replace with function body.
