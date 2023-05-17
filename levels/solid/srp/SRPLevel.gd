extends Level


var pw_digits := ["", "", ""]
var screens := []

onready var expressionScreen = find_node("Screen") as ScreenItem
onready var screen1 = find_node("Pass1") as ScreenItem
onready var screen2 = find_node("Pass2") as ScreenItem
onready var screen3 = find_node("Pass3") as ScreenItem
onready var door = find_node("Door") as DoorItem
onready var lights = $Item/Lights
onready var timer = $ExpressionChanger
onready var checkerTimer = $PasswordChecker
onready var computer = find_node("Computer") as Computer


func _ready():
	change_expression()
	screens = [screen1, screen2, screen3]
	codingGUI.connect("item_pressed", self, "_on_item_pressed")


func change_expression():
	var expression = StringUtils.get_random_expression(2, "*", 3)
	expressionScreen.set_value(expression)
	var result = "%03d" % int(StringUtils.get_exp_result(expression))
	for i in 3:
		pw_digits[i] = result[i]
	checkerTimer.start()


func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_ExpressionChanger_timeout():
	change_expression()


func _on_PasswordChecker_timeout():
	var open_door = true
	for i in 3:
		if pw_digits[i] != screens[i].value:
			open_door = false
			break
	if open_door:
		lights.fire()


func _on_Door_opened():
	computer.is_interactable = false
	timer.stop()


func _on_item_pressed(item_name):
	if item_name == "Calculator":
		DialogicUtils.start_dialog(self, "srp_loop")
		codingGUI.disconnect("item_pressed", self, "_on_item_pressed")
