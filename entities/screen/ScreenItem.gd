class_name ScreenItem, "res://assets/icons/screen.svg"
extends Item


signal value_changed(new_val)

const SOUND_CHANGE = preload("res://assets/sounds/select_007.ogg")

export(String) var value := "" setget set_value
export(bool) var make_sound = true
export(bool) var can_set_value = false
export(bool) var connect_on_value_changed = false

onready var valueLabel = $Viewport/Label
var is_on = true

func _init():
	icon = preload("res://assets/icons/ic_screen.png")


func _ready():
	valueLabel.text = value
	sound_player = $Sound


func set_value(val: String):
	value = val
	if valueLabel:
		valueLabel.text = val
	if value != "":
		emit_signal("value_changed", val)
		if make_sound:
			play_sound(SOUND_CHANGE)


func apply_code():
	.apply_code()
	if connect_on_value_changed:
		connect("value_changed", code, "onValueChanged")



func screenOff():
	is_on = not is_on 
	play_anim("screenOff")
