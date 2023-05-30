extends Level


onready var door = find_node("Door") as DoorItem
onready var exitDoor = find_node("DoorSingle") as DoorItem
onready var computer = find_node("Computer") as Computer
onready var screen = find_node("Screen") as ScreenItem
onready var pwTimer = find_node("PwChanger") as Timer
onready var appearTimer = find_node("AppearTime") as Timer


func _ready():
	screen.set_value("")
	door.door_locked = true
	start_timer()
	PlayerUtils.get_player(get_tree()).connect("look_at_item", self, "_on_player_look_at_item")


func reset_pw():
	var pw = StringUtils.get_random_string(4)
	door.set_password(pw)
	screen.set_value(pw)


func start_timer():
	var random_time = rand_range(3, 6)
	pwTimer.start(random_time)


func _on_PwChanger_timeout():
	door.door_locked = false
	reset_pw()
	appearTimer.start()


func _on_AppearTime_timeout():
	if door.is_open:
		return
	door.door_locked = true
	screen.set_value("")
	start_timer()



func _on_DoorSingle_interact(door, player):
	end_level(player)


func _on_Door_opened():
	computer.is_interactable = false
	DialogicUtils.start_dialog(self, "Observer_2", "_on_dialogic_signal")


func _on_player_look_at_item(item_name: String):
	if item_name == "Door":
		DialogicUtils.start_dialog(self, "observer_0", "_on_dialogic_signal")
		PlayerUtils.get_player(get_tree()).disconnect("look_at_item", self, "_on_player_look_at_item")

#
#func _on_dialogic_signal(arg):
#	PlayerUtils.set_player_focus(get_tree(), false)
