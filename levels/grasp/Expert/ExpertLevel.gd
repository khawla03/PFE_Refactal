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
	PlayerUtils.get_player(get_tree()).connect("look_at_item", self, "_on_player_look_at_item")



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
	DialogicUtils.start_dialog(self, "Expert_2", "_on_dialogic_signal")
	timer.stop()


func _on_HintsTimer_timeout():
	DialogicUtils.start_dialog(self, "Hints_time", "_on_dialogic_signal")
	HintsTimer.stop()
	pass # Replace with function body.


func _on_player_look_at_item(item_name: String):
	if item_name == "Computer":
		DialogicUtils.start_dialog(self, "Expert_0", "_on_dialogic_signal")
		PlayerUtils.get_player(get_tree()).disconnect("look_at_item", self, "_on_player_look_at_item")



func _on_item_pressed(item_name):
	if item_name == "Main":
		DialogicUtils.start_dialog(self, "Expert_1")
		codingGUI.disconnect("item_pressed", self, "_on_item_pressed")


func _on_dialogic_signal(arg):
	PlayerUtils.set_player_focus(get_tree(), false)
	bonus = DialogicClass.get_variable("Bonus")
	if bonus==100:
		ActionsData.save_action('True answer on the quizz',level_info.title)
	elif bonus == -50:
		ActionsData.save_action('False answer on the quizz',level_info.title)
	
	print(bonus)
