extends Level


var expression = Expression.new()
var exp_result
var result1 = false
var result2 = false
var result3 = false

# Tuto
onready var door0 = $Tuto/Door0
onready var button0 = $Tuto/Button0
onready var screenOpTuto = $Tuto/Screen00
onready var screenResultTuto = $Tuto/Screen01

onready var screenOp1 = $Items/OP1
onready var screenResult1 = $Items/Result1
onready var screenOp2 = $Items/OP2
onready var screenResult2 = $Items/Result2
onready var screenOp3 = $Items/OP3
onready var screenResult3 = $Items/Result3
onready var lights = $Items/Lights
onready var door = $Items/Door 
onready var button1=$Items/Button1
onready var button2=$Items/Button2
onready var button3=$Items/Button3
onready var computer = find_node("Computer") as Computer


func _ready():
	var val = get_random_expression()
	screenOpTuto.set_value(val)
	screenResultTuto.set_value("?")
	screenResultTuto.connect("value_changed", self, "_on_Screen01_value_changed")
	expression.parse(val)
	exp_result = str(expression.execute())
	door0.set_password(exp_result)
	codingGUI.connect("exit_coding", self, "_on_applied")
	Constraints.check_all()


func get_random_expression():
	return StringUtils.get_random_expression(2, "+-")


func randomise_expressions():
	var val 
	if not result1:
		val = get_random_expression()
		screenOp1.set_value(val)
	if not result2:
		val = get_random_expression()
		screenOp2.set_value(val)
	if not result3:
		val = get_random_expression()
		screenOp3.set_value(val)


func _on_Screen01_value_changed(new_val):
	door0.open(new_val)


func _on_Button0_pressed():
	screenResultTuto.set_value(exp_result)


func _on_ValueChanger_timeout():
	randomise_expressions()


func _on_Result1_value_changed(new_val):
	var e = Expression.new()
	e.parse(screenOp1.value)
	var result = e.execute()
	if not result1 and str(result) == new_val:
		result1 = true
		door.open()


func _on_Result2_value_changed(new_val):
	var e = Expression.new()
	e.parse(screenOp2.value)
	var result = e.execute()
	if not result2 and str(result) == new_val:
		result2 = true
		door.open()


func _on_Result3_value_changed(new_val):
	var e = Expression.new()
	e.parse(screenOp3.value)
	var result = e.execute()
	if not result3 and str(result) == new_val:
		result3 = true
		door.open()


func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_Door_opened():
	computer.is_interactable = false
	

var nbPress=0
var nbPress1=0
func _on_Button1_pressed():
	if not Constraints.all_passed and nbPress<2:
		DialogicUtils.start_dialog(self, "dup_loop_0", "_on_dialogic_signal")
	nbPress1=nbPress1+1
	nbPress=nbPress1+nbPress2+nbPress3
	ActionsData.save_action('Button 1 Pressed',"number of tests :" + str(nbPress1))
	if (nbPress1 > 4 or nbPress>6) and not Constraints.all_passed:
		if door.is_open == false:
			DialogicUtils.start_dialog(self, "Hints", "_on_dialogic_signal")
			button1.disconnect("pressed",self,"_on_Button_pressed")

var nbPress2=0
func _on_Button2_pressed():
	if not Constraints.all_passed and nbPress<2:
		DialogicUtils.start_dialog(self, "dup_loop_0", "_on_dialogic_signal")
	nbPress2=nbPress2+1
	nbPress=nbPress1+nbPress2+nbPress3
	ActionsData.save_action('Button 2 Pressed',"number of tests :" + str(nbPress2))
	if (nbPress2 > 4 or nbPress>6) and not Constraints.all_passed:
		if door.is_open == false:
			DialogicUtils.start_dialog(self, "Hints", "_on_dialogic_signal")
			button1.disconnect("pressed",self,"_on_Button_pressed")

var nbPress3=0
func _on_Button3_pressed():
	if not Constraints.all_passed and nbPress<2:
		DialogicUtils.start_dialog(self, "dup_loop_0", "_on_dialogic_signal")
	nbPress3=nbPress3+1
	nbPress=nbPress1+nbPress2+nbPress3
	ActionsData.save_action('Button 3 Pressed',"number of tests :" + str(nbPress3))
	if (nbPress3 > 4 or nbPress>6) and not Constraints.all_passed :
		if door.is_open == false:
			DialogicUtils.start_dialog(self, "Hints", "_on_dialogic_signal")
			button1.disconnect("pressed",self,"_on_Button_pressed")


func _on_dialogic_signal(arg):
	PlayerUtils.set_player_focus(get_tree(), false)


func _on_applied():
	lights.reset()
	result1 = false
	result2 = false
	result3 = false


func _on_Computer_started_coding(player):
	DialogicUtils.start_dialog(self, "dup_1")
	computer.disconnect("started_coding", self, "_on_Computer_started_coding")
