class_name TeleporterItem
extends Item

export(String) var contact := "sender" setget set_contact
export(String) var message := "message" setget set_message
onready var namelabel = $Viewport/VBoxContainer/name
onready var messagelabel = $Viewport/VBoxContainer/message


signal value_changed(new_val)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	namelabel.text = contact
	play_anim("showVal")
	pass # Replace with function body.

func set_contact(val: String):
	contact = val
	if namelabel:
		namelabel.text = val
	if contact != "":
		emit_signal("value_changed", val)

func set_message(val: String):
	contact = val
	if messagelabel:
		messagelabel.text = val
	if message != "":
		emit_signal("value_changed", val)

func interact(player):
	set_contact("from: StationB")
	set_message("Message body")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
