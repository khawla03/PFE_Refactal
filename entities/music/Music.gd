class_name Music
extends AudioStreamPlayer


const MUSIC_MENU = 0
const MUSIC_IN_GAME = 1

const menu_tracks = [preload("res://assets/music/Kozirsky-New-Land.ogg")]
const in_game_tracks = [
	preload("res://assets/music/atw-Corona-Borealis.ogg"),
	preload("res://assets/music/atw-Sternstrom.ogg")
	]

export(int, "Menu music", "In-game music") var type
var tracks := []
var tween_start_action: FuncRef = null
var tween_complete_action: FuncRef = null

onready var tween = Tween.new()


func _ready():
	randomize()
	tween.connect("tween_started", self, "tween_started")
	tween.connect("tween_completed", self, "tween_completed")
	add_child(tween)
	match type:
		MUSIC_MENU:
			tracks = menu_tracks
		MUSIC_IN_GAME:
			tracks = in_game_tracks
	if autoplay:
		play_music(false)


func play_music(smooth = true, duration = 1):
	stream = tracks[randi() % tracks.size()]
	if smooth:
		tween_start_action = funcref(self, "play")
		tween.interpolate_property(self, "volume_db", -80, 0, duration, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
	else:
		play()


func stop_music(smooth = true, duration = 1):
	if smooth:
		tween_complete_action = funcref(self, "stop")
		tween.interpolate_property(self, "volume_db", volume_db, -80, duration, Tween.TRANS_QUART, Tween.EASE_IN)
		tween.start()
	else:
		stop()



func pause_music(smooth = true, duration = 1):
	if smooth:
		tween_complete_action = funcref(self, "pause")
		tween.interpolate_property(self, "volume_db", volume_db, -80, duration, Tween.TRANS_QUART, Tween.EASE_IN)
		tween.start()
	else:
		stop()


func resume_music(smooth = true, duration = 1):
	if smooth:
		tween_start_action = funcref(self, "resume")
		tween.interpolate_property(self, "volume_db", -80, 0, duration, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
	else:
		stop()


func pause():
	stream_paused = true


func resume():
	stream_paused = false


func tween_started(object, key):
	if tween_start_action:
		tween_start_action.call_func()
		tween_start_action = null


func tween_completed(object, key):
	if tween_complete_action:
		tween_complete_action.call_func()
		tween_complete_action = null
