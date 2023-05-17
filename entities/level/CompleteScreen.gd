extends CanvasLayer


signal return_to_menu()
signal restart_level()
signal next_level()

const ANIM_NUMBER_DURATION = 1
const SOUND_TICK = preload("res://assets/sounds/tick_001.ogg")

var metrics := {}
var score := 0
var show_level_report = true
var _animated_label = null

onready var anim = $AnimationPlayer
onready var nextLevelButton = $Background/MarginContainer/VBoxContainer/HBoxContainer/ContinueButton
onready var lineNumber = find_node("LinesNumber") as Label
onready var cycval = find_node("CycValue") as Label
onready var scoreNumber = find_node("ScoreNumber") as Label
onready var secondsLabel = find_node("Seconds") as Label
onready var minutesLabel = find_node("Minutes") as Label
onready var sound = find_node("Sound") as AudioStreamPlayer


func _ready():
	anim.play("show_title")
	if not show_level_report:
		anim.queue("show_no_report")
	else:
		# Set metrics labels
		lineNumber.text = str(metrics["lines"])
		cycval.text = str(metrics["cyc"])
		secondsLabel.text = str(metrics["seconds"])
		minutesLabel.text = str(metrics["minutes"])
		# Calculate score
		scoreNumber.text = str(score)
		anim.queue("show_lines")
		anim.queue("show_time")
		anim.queue("show_score")
	anim.queue("show_buttons")


func animate_number(label: NodePath, format := ""):
	var label_node = get_node(label)
	var tw = Tween.new()
	_animated_label = label_node
	var final_val
	final_val = int(label_node.text)
	tw.interpolate_method(
		self, 
		"set_label", 
		0, 
		final_val, 
		ANIM_NUMBER_DURATION, 
		Tween.TRANS_CIRC, 
		Tween.EASE_OUT)
	sound.stream = SOUND_TICK
	add_child(tw)
	tw.start()


func set_label(text: int):
	if _animated_label:
		_animated_label.text = "%02d" % int(text)
		sound.play()


func check_continue_button():
	nextLevelButton.disabled = get_parent().level_info.next_level == null


func _on_ReturnButton_pressed():
	emit_signal("return_to_menu")


func _on_RestartButton_pressed():
	emit_signal("restart_level")


func _on_ContinueButton_pressed():
	emit_signal("next_level")


func _on_SkipButton_button_up():
	if anim.get_queue().empty():
		$SkipButton.hide()
	var length = anim.current_animation_length
	var position = anim.current_animation_position
	anim.advance(length - position)


func _on_AnimationPlayer_animation_finished(anim_name):
	$SkipButton.hide()
