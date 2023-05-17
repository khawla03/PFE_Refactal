extends Level

onready var door = find_node("Door") as DoorItem
onready var computer = find_node("Computer") as Computer
onready var oxBottles = find_node("ox bottles") as OxBottlesItem
onready var timer=$CheckTimer
onready var door2 = find_node("DoorSingle2") as DoorItem



# Called when the node enters the scene tree for the first time.
func _ready():
	oxBottles.empty()
	timer.start()
	pass # Replace with function body.


func _on_ox_bottles_interact(oxBottles,player):
	if oxBottles.is_full:
		door.open()



func _on_CheckTimer_timeout():
	if oxBottles.is_full:
		door.open()
	pass # Replace with function body.


func _on_DoorSingle2_interact(door2, player):
	end_level(player)

