extends Level


onready var button = $Items/Button
onready var lights = $Items/Lights
onready var door1 = $Items/Door
onready var screen_l = $Items/ScreenL
onready var screen_r = $Items/ScreenR
onready var door = $Items/Door2
onready var computer = find_node("Computer") as Computer


func _on_Button_pressed():
	door1.open()


func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_PasswordChanger_timeout():
	screen_l.set_value(StringUtils.get_random_number(2))
	screen_r.set_value(StringUtils.get_random_number(2))
	door.set_password(int(screen_l.value) + int(screen_r.value))


func _on_Door2_opened():
	computer.is_interactable = false
