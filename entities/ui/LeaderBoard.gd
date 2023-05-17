extends CanvasLayer


const SHOW_DURATION = 0.3

onready var board = find_node("Leaderboard") as Control
onready var bg = find_node("Background") as ColorRect
onready var anim = $AnimationPlayer
onready var subScoreLabel = find_node("SubmittedScore") as Label
onready var rankLabel = find_node("Rank") as Label
onready var localScoreLabel = find_node("LocalScore") as Label
onready var infoLabel = find_node("Info") as Label
onready var nameEdit = find_node("NameEdit") as LineEdit
onready var submitButton = find_node("Submit") as Button


func _ready():
	bg.rect_pivot_offset.x = bg.rect_size.x
	var total_score = int(Progress.get_total_score())
	var score_submitted = Vars.get_var("submitted_score") != null
	subScoreLabel.text = str(Vars.get_var("submitted_score")) if score_submitted else "Finish all levels to submit"
	localScoreLabel.text = str(total_score)
	nameEdit.text = Vars.get_var("player_name") if Vars.get_var("player_name") else ""
	var enable_submit = score_submitted and (Vars.get_var("submitted_score") < total_score)
	nameEdit.editable = enable_submit
	submitButton.disabled = not enable_submit
	infoLabel.visible = not enable_submit
	show()
	if score_submitted:
		yield(SilentWolf.Scores.get_score_position(Vars.get_var("submitted_score")), "sw_position_received")
		var position = SilentWolf.Scores.position
		rankLabel.text = str(position)


func show():
	anim.play("show")


func hide():
	anim.play("hide")


func _show_rect(node_path: NodePath):
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


func _hide_rect(node_path: NodePath):
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


func _on_Leaderboard_close():
	hide()


func _on_Submit_button_up():
	Progress.submit_score(nameEdit.text, Progress.get_total_score())
	hide()
	Progress.show_leaderboard()


func _on_NameEdit_text_changed(new_text):
	submitButton.disabled = new_text == ""
