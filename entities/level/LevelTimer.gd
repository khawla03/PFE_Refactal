class_name LevelTimer
extends CanvasLayer


var seconds := 0
var minutes := 0

onready var root = find_node("Root") as Control
onready var timer = find_node("Timer") as Timer
onready var minutesLabel = find_node("MinutesLabel") as Label
onready var secondsLabel = find_node("SecondsLabel") as Label


func _ready():
	timer.paused = true


func start():
	timer.paused = false


func stop():
	timer.paused = true


func show():
	root.show()


func hide():
	root.hide()

func update_ui():
	secondsLabel.text = "%02d" % seconds
	minutesLabel.text = "%02d" % minutes


func _on_Timer_timeout():
	if seconds < 59:
		seconds += 1
	else:
		seconds = 0
		minutes += 1
	update_ui()
