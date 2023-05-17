extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

export(bool) var repeat = false
export(bool) var autostart = false

var amplitude = 0
var delete_when_done = false
var last_duration = 0
var last_freq = 0

onready var camera

onready var vtween = $VTween
onready var htween = $HTween
onready var durationTimer = $Duration
onready var frequencyTimer = $Frequency


func _ready():
	camera = get_parent()
	if autostart:
		shake(false)


func shake(temp, duration = 1, frequency = 2, amplitude = 0.1):
	last_duration = duration
	last_freq = frequency
	delete_when_done = temp
	self.amplitude = amplitude
	durationTimer.wait_time = duration
	frequencyTimer.wait_time = 1 / float(frequency)
	durationTimer.start()
	frequencyTimer.start()
	_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	htween.interpolate_property(camera, "h_offset", camera.h_offset, rand.x, frequencyTimer.wait_time, TRANS, EASE)
	vtween.interpolate_property(camera, "v_offset", camera.v_offset, rand.y, frequencyTimer.wait_time, TRANS, EASE)
	htween.start()
	vtween.start()

func _reset():
	htween.interpolate_property(camera, "h_offset", camera.h_offset, 0, frequencyTimer.wait_time, TRANS, EASE)
	vtween.interpolate_property(camera, "v_offset", camera.v_offset, 0, frequencyTimer.wait_time, TRANS, EASE)
	htween.start()
	vtween.start()

func _on_Frequency_timeout():
	_new_shake()


func _on_Duration_timeout():
	_reset()
	frequencyTimer.stop()
	if delete_when_done:
		queue_free()
	if repeat:
		shake(false, last_duration, last_freq, amplitude)
