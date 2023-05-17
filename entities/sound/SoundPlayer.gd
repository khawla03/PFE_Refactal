class_name SoundPlayer
extends AudioStreamPlayer


const CLICK = preload("res://assets/sounds/click5.ogg")
const SWITCH = preload("res://assets/sounds/switch37.ogg")


func play_sound(sound):
	stop()
	stream = sound
	play()
