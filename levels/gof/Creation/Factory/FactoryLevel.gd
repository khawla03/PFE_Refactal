extends Level



onready var Key1 = find_node("Key1") as ScreenItem
onready var Key2 = find_node("Key2") as ScreenItem
onready var Room1 = find_node("Room1") as RoomMapItem
onready var Room2 = find_node("Room2") as RoomMapItem
onready var door = find_node("Door") as DoorItem
onready var door2 = find_node("DoorSingle2") as DoorItem
onready var timer = $ExpressionChanger
onready var checkerTimer = $PasswordChecker
onready var computer = find_node("Computer") as Computer
onready var button = $Programmable/Button
var pw_digits

func _ready():
	change_key2()
	change_key1()
	PlayerUtils.get_player(get_tree()).connect("look_at_item", self, "_on_player_look_at_item")


func change_key1():
	var pw = StringUtils.get_random_string(4)
	Room1.set_password(pw)
	Key1.set_value(pw)
	#Room1.openRoom(pw)


func change_key2():
	var expression = StringUtils.get_random_expression(1, "*", 1)
	Key2.set_value(expression)
	var result =StringUtils.get_exp_result(expression)
	Room2.set_password(result)
	pw_digits= result
	#Room2.openRoom(result)
	checkerTimer.start()
	
func _on_ExpressionChanger_timeout():
	change_key2()
	change_key1()


func _on_PasswordChecker_timeout():
	if Room1.is_open and Room2.is_open:
		door.open()
	pass # Replace with function body.





func _on_DoorSingle2_interact(door, player):
	end_level(player)

var nbPress=0
func _on_Button_pressed():
	nbPress=nbPress+1
	ActionsData.save_action('Button Pressed',"number of tests :" + str(nbPress))
	if nbPress > 4:
		if door.is_open == false:
			DialogicUtils.start_dialog(self, "Hints", "_on_dialogic_signal")
			button.disconnect("pressed",self,"_on_Button_pressed")

	pass # Replace with function body.


func _on_Door_opened():
	button.disconnect("pressed",self,"_on_Button_pressed")
	DialogicUtils.start_dialog(self, "Factort_1", "_on_dialogic_signal")
	computer.is_interactable = false
	pass # Replace with function body.


func _on_dialogic_signal(arg):
	PlayerUtils.set_player_focus(get_tree(), false)
	bonus = DialogicClass.get_variable("Bonus")
	if bonus=="100":
		ActionsData.save_action('True answer on the quizz',level_info.title)
	elif bonus == "-50":
		ActionsData.save_action('False answer on the quizz',level_info.title)
	
#
func _on_player_look_at_item(item_name: String):
	if item_name == "Computer":
		DialogicUtils.start_dialog(self, "Factory_0", "_on_dialogic_signal")
		PlayerUtils.get_player(get_tree()).disconnect("look_at_item", self, "_on_player_look_at_item")

