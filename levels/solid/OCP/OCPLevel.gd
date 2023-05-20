extends Level



var screens := []


onready var screen1 = find_node("ScreenItem") as ScreenItem
onready var screen2 = find_node("ScreenItem2") as ScreenItem
onready var screen3 = find_node("ScreenItem3") as ScreenItem
onready var screen4 = find_node("ScreenItem4") as ScreenItem
onready var door = find_node("Door") as DoorItem
onready var doorsingle = find_node("DoorSingle") as DoorItem

onready var timer = $ExpressionChanger
onready var checkerTimer = $PasswordChecker
onready var computer = find_node("Computer") as Computer
var password=""

func _ready():
	screens = [screen1, screen2, screen3,screen4]
	change_expression()
	#codingGUI.connect("item_pressed", self, "_on_item_pressed")


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
	print(password)
	print("/n")
	print("--------------------")
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


func _on_item_pressed(item_name):
	codingGUI.disconnect("item_pressed", self, "_on_item_pressed")
