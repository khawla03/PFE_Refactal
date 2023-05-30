extends Level



var screens := []


onready var screen1 = find_node("ScreenItem") as ScreenItem
onready var screen2 = find_node("ScreenItem2") as ScreenItem
onready var screen3 = find_node("ScreenItem3") as ScreenItem
onready var screen4 = find_node("ScreenItem4") as ScreenItem
onready var door = find_node("Door") as DoorItem
onready var doorsingle = find_node("DoorSingle") as DoorItem

onready var timer = $ExpressionChanger
onready var button = $Button
onready var checkerTimer = $PasswordChecker
onready var computer = find_node("Computer") as Computer
var password=""

func _ready():
	screens = [screen1, screen2, screen3,screen4]
	change_expression()
	codingGUI.connect("item_pressed", self, "_on_item_pressed")
	PlayerUtils.get_player(get_tree()).connect("look_at_item", self, "_on_player_look_at_item")


func change_expression():
	password=""
	var expression
	for i in 4:
		expression = StringUtils.get_random_string(3)
		screens[i].value = expression
	var y = randi() % 4
	screens[y].value="000"
	for i in 4:
		if screens[i].value!="000":
			password = password + str(screens[i].value)
			
	door.set_password(password)
	checkerTimer.start()


func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_ExpressionChanger_timeout():
	change_expression()


#func _on_PasswordChecker_timeout():
#	var open_door = true
#	for i in 3:
#		if pw_digits[i] != screens[i].value:
#			open_door = false
#			break



func _on_Door_opened():
	computer.is_interactable = false
	timer.stop()
	button.disconnect("pressed",self,"_on_Button_pressed")
	DialogicUtils.start_dialog(self, "OCP_2", "_on_dialogic_signal")


func _on_item_pressed(item_name):
	if item_name == "PasswordSetter":
		DialogicUtils.start_dialog(self, "OCP_1")
		codingGUI.disconnect("item_pressed", self, "_on_item_pressed")


func _on_player_look_at_item(item_name: String):
	if item_name == "Computer":
		DialogicUtils.start_dialog(self, "OCP_0", "_on_dialogic_signal")
		PlayerUtils.get_player(get_tree()).disconnect("look_at_item", self, "_on_player_look_at_item")


var nbPress=0

func _on_Button_pressed():
	nbPress=nbPress+1
	ActionsData.save_action('Button Pressed',"number of tests :" + str(nbPress))
	if nbPress > 4:
		if door.is_open == false:
			DialogicUtils.start_dialog(self, "Hints", "_on_dialogic_signal")
			button.disconnect("pressed",self,"_on_Button_pressed")
	pass # Replace with function body.

#
#func wait(s):
#	var t = Timer.new()
#	t.set_wait_time(s)
#	t.set_one_shot(true)
#	self.add_child(t)
#	t.start()
#	yield(t, "timeout")
#	t.queue_free()
