extends Level

onready var computer = find_node("Computer") as Computer
onready var door1 = $Door1
onready var projector = $Projector
onready var message = $message


func _ready():
	projector.set_message("hello")
