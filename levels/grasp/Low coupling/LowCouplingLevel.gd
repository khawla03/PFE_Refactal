extends Level

onready var passwordScreen = find_node("Screen") as ScreenItem
onready var door = find_node("Door") as DoorItem
onready var doorSingle = find_node("DoorSingle2") as DoorItem
onready var computer = find_node("Computer") as Computer
onready var button = find_node("Button") as ButtonItem
onready var timer = $PasswordChanger
var pwd:String

# Called when the node enters the scene tree for the first time.
func _ready():
	change_value()
	
	codingGUI.connect("item_pressed", self, "_on_item_pressed")
	Constraints.check_all()

	


func change_value():
	pwd = StringUtils.get_random_string(4)
	door.set_password(pwd)
	passwordScreen.set_value(pwd)
	timer.start()


func _on_PasswordChanger_timeout():
	change_value()

var nbPress=0

func _on_Button_pressed():
	if Constraints.all_passed:
		door.open(pwd)
		pass # Replace with function body.
	nbPress=nbPress+1
	ActionsData.save_action('Button Pressed',"number of tests :" + str(nbPress))
	if nbPress > 4:
		if door.is_open == false:
			DialogicUtils.start_dialog(self, "Hints", "_on_dialogic_signal")
			button.disconnect("pressed",self,"_on_Button_pressed")


func _on_DoorSingle2_interact(doorSingle, player):
	end_level(player)


func _on_item_pressed(item_name):
	if item_name == "Button":
		DialogicUtils.start_dialog(self, "LowCoupling_0")
		codingGUI.disconnect("item_pressed", self, "_on_item_pressed")


func _on_Door_opened():
	button.disconnect("pressed",self,"_on_Button_pressed")
	DialogicUtils.start_dialog(self, "LowCoupling_1", "_on_dialogic_signal")
	computer.is_interactable = false
	pass # Replace with function body.

