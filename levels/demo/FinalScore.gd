extends CanvasLayer


const SHOW_DURATION = 0.3
const ANIM_NUMBER_DURATION = 2
const SOUND_TICK = preload("res://assets/sounds/tick_001.ogg")

var _animated_label
var total_score := 0

onready var sound = find_node("Sound") as AudioStreamPlayer
onready var anim = $AnimationPlayer
onready var submit = find_node("Submit") as Button
onready var scoreLabel = find_node("Score") as Label
onready var nameEdit = find_node("NameEdit") as LineEdit


func _ready():
	Vars.show_submit_screen = false
	total_score = Progress.get_total_score()
	scoreLabel.text = str(total_score)
	anim.play("show")


func queue_free():
	Progress.show_leaderboard()
	.queue_free()


func show_rect(node_path: NodePath):
	var tween = Tween.new()
	var node = get_node(node_path) as Control
	tween.interpolate_property(
		node,
		"rect_scale",
		Vector2(0, 1),
		Vector2(1, 1),
		SHOW_DURATION,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	tween.connect("tween_completed", tween, "queue_free")
	add_child(tween)
	tween.start()


func hide_rect(node_path: NodePath):
	var tween = Tween.new()
	var node = get_node(node_path) as Control
	tween.interpolate_property(
		node,
		"rect_scale",
		Vector2(1, 1),
		Vector2(0, 1),
		SHOW_DURATION,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	tween.connect("tween_completed", tween, "queue_free")
	add_child(tween)
	tween.start()


func animate_number(label: NodePath):
	var label_node = get_node(label)
	var tw = Tween.new()
	var final_val
	_animated_label = label_node
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
		_animated_label.text = str(text)
		sound.play()


func _on_LineEdit_text_changed(new_text):
	submit.disabled = new_text == ""


func _on_Submit_button_up():
	var player_name = nameEdit.text
	Progress.submit_score(player_name, total_score)
	anim.play("hide")
