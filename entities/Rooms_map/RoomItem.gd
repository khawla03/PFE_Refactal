class_name RoomMapItem
extends Item

signal opened()
var password := "" setget set_password
var is_open := false


func _init():
	icon = preload("res://assets/icons/ic_door.png")
	interaction_message = "to open"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func openRoom(pw = ""):
	print(pw)
	print("password:")
	print(password)
	print(is_open)
	if is_open:
		print("is_open")
		return
	if (str(pw) == password):
		if play_anim("Open"):
			is_open = not is_open
			play_anim("Open")
			emit_signal("opened")
			print(is_open)
			
		return


func closeRoom():
	if is_open:
		if play_anim("Close"):
			is_open= not is_open

func set_password(pw):
	password = str(pw)

