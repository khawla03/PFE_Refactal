extends Level

onready var door = $Door
onready var room = $Room
onready var doorsingle = $DoorSingle
onready var timer=get_node("Timer")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(10)
	print("test3")
	room.set_password("123")
	pass # Replace with function body.



func _on_Door_interact(door, player):
	door.open()
	room.openRoom("123")
	timer.start()
	pass # Replace with function body.


func _on_DoorSingle_interact(door, player):
	end_level(player)
	pass # Replace with function body.


func _on_Timer_timeout():
	room.closeRoom()
	DialogicUtils.start_dialog(self, "test3")
	pass # Replace with function body.
