class_name MessageScreenItem
extends Item

export(String) var contact := "Station B" setget set_contact
export(String) var message := "Hello, It's Bazz" setget set_message
onready var namelabel = $Viewport/VBoxContainer/name
onready var messagelabel = $Viewport/VBoxContainer/message

var is_on := true

func _ready():
	set_contact(contact)
	set_message(message)
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


func shutDown():
	if is_on:
		play_anim("ShutDown")
		is_on = not is_on
