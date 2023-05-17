class_name DoorItem, "res://assets/icons/door.svg"
extends Item


signal interact(door, player)
signal opened()

export(NodePath) var lights_path
export(bool) var door_locked = false

const SOUND_DENIED = preload("res://assets/sounds/access_denied.ogg")

var password := "" setget set_password
var is_open := false

onready var sound = $AudioStreamPlayer3D
onready var lights = get_node(lights_path)


func _init():
	icon = preload("res://assets/icons/ic_door.png")
	interaction_message = "to open"


func _ready():
	if lights:
		lights.connect("completed", self, "on_light_completed")


func open(pw = ""):
	if is_open:
		return
	if (str(pw) == password) and (not door_locked):
			if lights:
				lights.fire()
				return
			if play_anim("open"):
				is_open = not is_open
				emit_signal("opened")
			return
	else:
		if lights:
			lights.reset()
		sound.stream = SOUND_DENIED
		sound.play()
	print(is_open)

func close():
	if is_open and play_anim("close"):
		is_open = not is_open


func on_light_completed():
	if play_anim("open"):
		is_open = not is_open
		emit_signal("opened")


func set_password(pw):
	password = str(pw)


func interact(player):
	emit_signal("interact", self, player)

