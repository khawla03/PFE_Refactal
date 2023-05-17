extends Level
var pw_digits:String

onready var expressionScreen = find_node("Screen") as ScreenItem
onready var resultScreen = find_node("ResultScreen") as ScreenItem
onready var door = find_node("Door") as DoorItem
onready var timer = $ExpressionChanger
onready var checkerTimer = $PasswordChecker
onready var HintsTimer = $HintsTimer
onready var computer = find_node("Computer") as Computer
onready var lights = $Items/Lights

func _ready():
	HintsTimer.start()
	change_expression()
	codingGUI.connect("item_pressed", self, "_on_item_pressed")
	


func change_expression():
	var expression = StringUtils.get_random_expression(1, "*", 1)
	expressionScreen.set_value(expression)
	var result =StringUtils.get_exp_result(expression)
	pw_digits= result
	checkerTimer.start()



func _on_ExpressionChanger_timeout():
	change_expression()
	


func _on_PasswordChecker_timeout():
	var open_door = true
	if int(pw_digits) != int(resultScreen.value):
		open_door = false
			
	if open_door:
		lights.fire()


func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_Door_opened():
	computer.is_interactable = false
	#DialogicUtils.start_dialog(self, "Expert_2", "_on_dialogic_signal")
	timer.stop()


func _on_HintsTimer_timeout():
	DialogicUtils.start_dialog(self, "Hints_time", "_on_dialogic_signal")
	HintsTimer.stop()
	pass # Replace with function body.


func _on_dialogic_signal(arg):
	PlayerUtils.set_player_focus(get_tree(), false)
